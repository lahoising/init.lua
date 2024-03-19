local CACHE_PATH = vim.fn.stdpath("data") .. package.config:sub(1, 1) .. "profile_cache"

return {
  cache_path = function ()
    return CACHE_PATH
  end,

  read = function ()
    if vim.fn.filereadable(CACHE_PATH) == 0 then
      return {}
    end

    local data = vim.fn.readfile(CACHE_PATH)
    local deserialized_data = {}
    for i, _ in ipairs(data) do
      if i % 2 == 1 then
        local key = data[i]
        local val = data[i+1]
        deserialized_data[key] = val
      end
    end
    return deserialized_data
  end,

  write = function(values)
    local serialized_data = {}
    for key, val in pairs(values) do
      table.insert(serialized_data, key)
      table.insert(serialized_data, val)
    end
    vim.fn.writefile(serialized_data, CACHE_PATH)
  end
}
