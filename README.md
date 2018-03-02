# cl.vim

Helps to execute Microsoft C/C++ compiler `CL` and to store its results into
quickfix.

## Prerequiresite

- Vim.7x
- Visual Studio (Tested with 2017 Community)
  - Vim must be executed on Command Prompt pre-configured by `vcvarsall`
    - Use Developer Command Prompt, or consider [vcinit](https://github.com/retorillo/vcinit).
- (Optional) [7zip](https://chocolatey.org/packages/7zip)
  - Automatically compute hash for compiler artifacts when `7z` command is available.
  - To change hash function, set `g:cl#hash` (default: `sha1`)

## Installation (Pathogen)

```batchfile
git clone https://github.com/retorillo/cl.vim.git %userprofile%/vimfiles/bundle/cl.vim
```

## Usage

```vimscript
:CL /EHsc %
```

- When compiling failed, `:cn` command can takes you to error line.
- You can use `:clist` to list errors. And, of course, `:clist!` (with bang)
  allows to show all stdout/stderr lines.
- The original `CL` syntax may be able to used in almost cases. (`:CL /?` can
  dumps help message)

## Localization

If garbled, set `cl#encoding` on your vimrc as below:

```vimscript
" For Shift-JIS environment
let g:cl#encoding='sjis'
```

## License

MIT License

Copyright © 2018 Retorillo
