local conform = require("conform")
local gitsigns = require("gitsigns")

local M = {}

-- Based on functions from wenjinn@ and linusboehm@ on this GitHub issue
-- https://github.com/stevearc/conform.nvim/issues/92
function M.format_modifications()
  local hunks = gitsigns.get_hunks()
  if hunks == nil then return end

  local ranges = M._build_hunk_ranges(hunks)
  M._format_ranges(ranges)
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
function M._format_ranges(ranges)
  for _, range in ipairs(ranges) do
    conform.format({ range = range })
  end
end

return M
