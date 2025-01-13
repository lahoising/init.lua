local conform = require("conform")
local gitsigns = require("gitsigns")

local M = {
  blocked_filetypes = {
    lua = true,
  },
}

-- Based on functions from wenjinn@ and linusboehm@ on this GitHub issue
-- https://github.com/stevearc/conform.nvim/issues/92
function M.format_modifications(bufnr)
  local ft = vim.bo[bufnr].filetype
  if not M._is_filetype_supported(ft) then
    return false
  end

  local hunks = gitsigns.get_hunks(bufnr)
  if hunks == nil then return end

  local ranges = M._build_hunk_ranges(hunks)
  return M._format_ranges(bufnr, ranges)
end

--- @private
function M._is_filetype_supported(ft)
  return M.blocked_filetypes[ft] == nil
end

--- @private
function M._build_hunk_ranges(hunks)
  local ranges = {}
  for _, change in ipairs(hunks) do
    if change.type ~= "delete" then
      -- Insert new range at the start, so formatting happens from the bottom up.
      -- This avoids line changes form messing up the ranges.
      table.insert(ranges, 1, {
        start = { change.added.start, 0 },
        ["end"] = { change.added.start + change.added.count, 0 },
      })
    end
  end
  return ranges
end

--- @private
function M._format_ranges(bufnr, ranges)
  local formatting_attempted = false

  for _, range in ipairs(ranges) do
    local formatting_result = conform.format({
      bufnr = bufnr,
      range = range
    })
    formatting_attempted = formatting_attempted or formatting_result
  end

  return formatting_attempted
end

return M
