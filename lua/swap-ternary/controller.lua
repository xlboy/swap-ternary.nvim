-- luacheck: globals vim

local M = {}

--- @alias FileTypeIsXXX fun(type: string): boolean

local file_type = {
  is_ts_or_js = function(type) --- @type FileTypeIsXXX
    return string.match(type, "typescript") or string.match(type, "javascript")
  end,
}

---@return NodeProcessor
local function get_node_processor(buf)
  local _file_type = vim.api.nvim_buf_get_option(buf, "filetype") ---@type string
  if file_type.is_ts_or_js(_file_type) then
    return require("swap-ternary.node-processor.js-or-ts")
  end
end

function M.start()
  local current_buf = vim.api.nvim_get_current_buf()

  local node_tree = vim.treesitter.get_parser(current_buf)
  if not node_tree then
    return vim.notify("[swap-ternary] Node tree is empty", vim.log.levels.ERROR)
  end

  local node_processor = get_node_processor(current_buf)

  local ternary_node = node_processor.find_ternary_node_at_cursor(node_tree)
  if not ternary_node then
    return vim.notify(
      "[swap-ternary] Did not find the 'ternary expression' at the current cursor position.",
      vim.log.levels.WARN
    )
  end

  local target_nodes = node_processor.get_target_nodes(ternary_node)
  if not target_nodes.alt or not target_nodes.cons or not target_nodes.cond then
    return vim.notify("[swap-ternary] `target_nodes` error", vim.log.levels.ERROR)
  end

  local replaced_text = node_processor.recombination(target_nodes, current_buf)
  --- `t_n_s` = `ternary_node_start`, `t_n_e` = `ternary_node_end`
  local t_n_s_line, t_n_s_col, t_n_e_line, t_n_e_col = ternary_node:range()
  vim.api.nvim_buf_set_text(current_buf, t_n_s_line, t_n_s_col, t_n_e_line, t_n_e_col, { replaced_text })
end

return M
