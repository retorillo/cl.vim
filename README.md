# cl.vim

ClCommand helps to execute Microsoft C/C++ compiler `CL` and to store its
results into quickfix.

## Prerequiresite

- Vim.7x (To use `g:cl#encoding`, must be Vim 8.0.0420 or later)
- Visual Studio (Tested with 2017 Community)
  - Vim must be executed on Command Prompt pre-configured by `vcvarsall`
    - Use Developer Command Prompt or consider [vcinit](https://github.com/retorillo/vcinit).

## Installation (Pathogen)

```
git clone https://github.com/retorillo/cl.vim.git ~/.vim/bundle/cl.vim
```

## Localization

If garbled, set `cl#encoding` on your vimrc as below:

```viml
" For Shift-JIS environment
let g:cl#encoding=sjis
```

**NOTE:** To use this feature, Vim must be Ver.8.0.0420 or later.

## License

MIT License

Copyright © 2018 Retorillo
