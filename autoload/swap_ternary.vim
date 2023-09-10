scriptencoding utf-8

function! swap_ternary#swap() abort
  if has('nvim')
    lua require'swap-ternary'.swap()
  endif
endfunction
