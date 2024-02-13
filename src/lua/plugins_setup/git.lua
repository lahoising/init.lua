return {
  {
    "airblade/vim-gitgutter",
    config = function ()
      vim.keymap.set('n', '<leader>gn', '<Cmd>GitGutterNextHunk<CR>', {})
      vim.keymap.set('n', '<leader>gp', '<Cmd>GitGutterPrevHunk<CR>', {})
      vim.keymap.set('n', '<leader>gu', '<Cmd>GitGutterUndoHunk<CR>', {})
      vim.keymap.set('n', '<leader>gd', '<Cmd>GitGutterPreviewHunk<CR>', {})
    end
  },
}
