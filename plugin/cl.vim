command!
  \ -nargs=*
  \ -complete=file
  \ CL
  \ call cl#exec('<args>')

function! cl#exec(clparam)
  let last_mp=&mp
  let &mp='cl'
  let last_efm=&efm
  try
    if exists('g:cl#errorformat')
      let &efm=g:cl#errorformat
    else
      let &efm='%f(%l): %trror %m'
        \.',%f(%l): $tarning %m'
        \.',%f(%l): %*[a-z]: %m'
        \.',%f(%l): %m'
        \.',%*[^:]: %trror %m'
        \.',%*[^:]: fatal %trror %m'
    endif
    if exists('g:cl#encoding')
      let last_menc=&menc
      let &menc=g:cl#encoding
    endif
    exec 'make '.a:clparam
  finally
    let &mp=last_mp
    let &efm=last_efm
    if exists('g:cl#encoding')
      let &menc=last_menc
    endif
  endtry
endfunction
