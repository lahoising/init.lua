local M = {}

function M.array_contains_item(array, item)
  for _, element in ipairs(array) do
    if element == item then return true end
  end
  return false
end

return M
