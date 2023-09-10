-- luacheck: globals vim
local M = {}

---@param buf integer
---@param node TSNode
function M.get_buf_texts_by_node(buf, node)
  local start_line, start_col, end_line, end_col = node:range()
  local node_text = vim.api.nvim_buf_get_text(buf, start_line, start_col, end_line, end_col, {})

  return node_text
end

--- @see <root>/tests/utils/merge-texts_spec.lua
--- @param texts string[][]
--- @return string[]
function M.merge_texts(texts)
  local result = {}
  ---@param _texts string[]
  for _, _texts in ipairs(texts) do
    if #result == 0 then
      result = _texts
    else
      local last_index = #result
      local last_text = result[last_index]
      local first_text = _texts[1]
      result[last_index] = last_text .. first_text
      for i = 2, #_texts do
        table.insert(result, _texts[i])
      end
    end
  end

  return result
end

return M
