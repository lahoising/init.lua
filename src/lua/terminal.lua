local toggleterm = require('toggleterm')

toggleterm.setup({
  size = 30,
  open_mapping = '<C-Bslash>',
})

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = { 'term://*' },
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set('t', '<Escape>', '<C-Bslash><C-N>', opts)
    vim.keymap.set({'t', 'n', 'i'}, '<C-j>', '<C-Bslash><C-N><C-w>j', opts)
    vim.keymap.set({'t', 'n', 'i'}, '<C-k>', '<C-Bslash><C-N><C-w>k', opts)
  end,
})
