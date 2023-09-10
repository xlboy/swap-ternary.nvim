-- luacheck: globals vim

local utils = require("swap-ternary.utils")
--- @type NodeProcessor
--- @diagnostic disable-next-line: missing-fields
local M = {}

function M.find_node_at_cursor(node_tree, node_type)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_line = cursor[1] - 1
  local cursor_col = cursor[2] - 1

  -- { start_line, start_col, end_line, end_col }
  -- return: TSNode
  local node = node_tree:named_node_for_range({ cursor_line, cursor_col, cursor_line, cursor_col + 1 })
  while node do
    if node:type() == node_type then
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
  local cond_texts = utils.get_buf_texts_by_node(buf, target_nodes.cond)
  local cons_texts = utils.get_buf_texts_by_node(buf, target_nodes.cons)
  local alt_texts = utils.get_buf_texts_by_node(buf, target_nodes.alt)

  return utils.merge_texts({ cond_texts, { " ? " }, alt_texts, { " : " }, cons_texts })
end

return M
