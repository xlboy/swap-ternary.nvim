-- luacheck: globals vim

--- @type NodeProcessor
---@diagnostic disable-next-line: missing-fields
local M = {}

function M.find_ternary_node_at_cursor(node_tree)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_line = cursor[1] - 1
  local cursor_col = cursor[2] - 1

  local node = node_tree:named_node_for_range({ cursor_line, cursor_col, cursor_line, cursor_col })
  while node do
    if node:type() == "ternary_expression" then
      return node
    end
    node = node:parent()
  end
end

function M.get_target_nodes(ternary_node)
  local target_nodes = {
    cond = nil,
    cons = nil,
    alt = nil,
  }

  for c_node, c_node_name in ternary_node:iter_children() do
    if c_node_name == "condition" then
      target_nodes.cond = c_node
    end
    if c_node_name == "consequence" then
      target_nodes.cons = c_node
    end
    if c_node_name == "alternative" then
      target_nodes.alt = c_node
    end
  end

  return target_nodes
end

function M.recombination(target_nodes, buf)
  local cond_start_line, cond_start_col, cond_end_line, cond_end_col = target_nodes.cond:range()
  local cons_start_line, cons_start_col, cons_end_line, cons_end_col = target_nodes.cons:range()
  local alt_start_line, alt_start_col, alt_end_line, alt_end_col = target_nodes.alt:range()

  local cond_text = vim.api.nvim_buf_get_text(buf, cond_start_line, cond_start_col, cond_end_line, cond_end_col, {})[1]
  local cons_text = vim.api.nvim_buf_get_text(buf, cons_start_line, cons_start_col, cons_end_line, cons_end_col, {})[1]
  local alt_text = vim.api.nvim_buf_get_text(buf, alt_start_line, alt_start_col, alt_end_line, alt_end_col, {})[1]

  local result = cond_text .. " ? " .. alt_text .. " : " .. cons_text

  return result
end

return M
