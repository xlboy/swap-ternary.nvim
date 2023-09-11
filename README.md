# 🌪️swap-ternary.nvim

Easily swap the values in a ternary expression

https://github.com/xlboy/swap-ternary.nvim/assets/63690944/2324c998-3e18-4989-9048-c9d9a4c01d41

## Supported languages

- `javascript`
- `javascriptreact`
- `typescript`
- `typescriptreact`
- `c`
- `cpp`
- `c#`
- `python`
- `java`

## Install

```lua
-- lazy.nvim
{ "xlboy/swap-ternary.nvim" }
```

## How to use?

Position the cursor over the ternary expression and then execute `:lua require('swap-ternary').swap()` or `:call swap_ternary#swap()`.

It's more convenient to define a keybinding with `<leader>`.

In `.vimrc`:

```vim
nnoremap <leader>S :call swap_ternary#swap()<CR>
" nnoremap <leader>S :lua require('swap-ternary').swap()<CR>
```

In `init.lua`:

```lua
vim.api.nvim_set_keymap('n', '<leader>S', ':lua require("swap-ternary").swap()<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>S', ':call swap_ternary#swap()<CR>', { noremap = true, silent = true })
```
