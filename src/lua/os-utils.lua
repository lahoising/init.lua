local M = {}

M.is_nixos = function()
  return vim.fn.hostname() == 'nixos'
end

return M
