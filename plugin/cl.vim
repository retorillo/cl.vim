command!
  \ -nargs=*
  \ -complete=file
  \ CL
  \ call cl#exec('<args>')

let g:cl#hash = 'sha1'
let g:cl#artifacts = []

function! cl#exec(clparam)
  if !executable('cl')
    echoerr 'cl compiler is not found on %PATH%'
    return
  endif
  let last_efm=&efm
  try
    if exists('g:cl#errorformat')
      let &efm=g:cl#errorformat
    else
      let &efm='%f(%l): %trror %m'
        \.',%f(%l): %tarning %m'
        \.',%f(%l): %*[a-z]: %m'
        \.',%f(%l): %m'
        \.',%*[^:]: %trror %m'
        \.',%*[^:]: fatal %trror %m'
    endif
    let rdir = system('cl ' . a:clparam)
    if exists('g:cl#encoding')
      let rdir = iconv(rdir, g:cl#encoding, 'utf-8')
    endif
    if v:shell_error == 0
      let g:cl#artifacts= []
      let rdirs = split(rdir, '\v\r?\n')
      for l in rdirs
        let ml = matchlist(l, '\v^/out:(.+\.(exe|obj))')
        if !empty(ml)
          call add(g:cl#artifacts, ml[1])
        endif
      endfor
      let g:cl#artifacts = filter(g:cl#artifacts, 'filereadable(v:val)')
      if !empty(g:cl#artifacts)
        call cl#report(rdir)
        echo printf('%d artifact%s found: ', len(g:cl#artifacts),
          \ len(g:cl#artifacts) == 1 ? ' was' : 's were')
        for file in g:cl#artifacts
          echo "\u2713 ". file . ' ' . cl#formatbyte(getfsize(file)). ' ' . cl#hash(file, g:cl#hash)
        endfor
      else
        " dump for help message
        for l in rdirs
          echo l
        endfor
      endif
    else
      call cl#report(rdir)
    endif
  finally
    let &efm=last_efm
  endtry
endfunction

function! cl#formatbyte(byte)
  let unit = 'bytes'
  let nrfmt = '%d'
  let byte = a:byte
  for u in ['KiB', 'MiB', 'GiB', 'TiB', v:null]
    if byte <= 1024 || u == v:null
      break
    endif
    let nrfmt = '%.2f'
    let unit = u
    let byte = byte / 1024.0
  endfor
  return printf(nrfmt.'%s', byte, unit)
endfunction

function! cl#report(rdir)
  cgetexpr a:rdir
  let cqf = cl#countqf({ 'w': 0, 'e' : 0 })
  " should run cgetexpr because return 0 regardless of warning errors.
  echo printf('CL exited with code 0x%04X (warning: %d, error: %d)',
    \ v:shell_error, cqf.w , cqf.e)
endfunction

function! cl#hash(file, func)
  if executable('7z')
    for l in split(system('7z h -scrc'.toupper(a:func).' '. shellescape(a:file)), '\v\r?\n')
      let m = matchlist(l, '\v^'.toupper(a:func).'\s+for\s+data:\s*([0-9A-F]+)')
      if !empty(m)
        return tolower(m[1])
      endif
    endfor
  endif
  return ''
endfunction

function! cl#countqf(initial)
  if empty(a:initial)
    let r = { }
  else
    let r = a:initial
  endif
  for i in getqflist()
    let t = tolower(i.type)
    if !has_key(r, t)
    let r[t] = 0
    endif
    let r[t] += 1
  endfor
  return r
endfunction
