-- luacheck: globals vim
local common = require("swap-ternary.node-processor.common")
local utils = require("swap-ternary.utils")

--- @type NodeProcessor
--- @diagnostic disable-next-line: missing-fields
local M = {}

function M.find_ternary_node_at_cursor(node_tree)
  return common.find_node_at_cursor(node_tree, "conditional_expression")
end

function M.get_target_nodes(ternary_node)
  --- [[
  --- `result = "11111" if True else "22222" or 1111`
  --- cond = `True`
  --- cons = `"11111"`
  --- alt = `"22222" or 1111`
  --- ]]

  local target_nodes = {
    cond = ternary_node:named_child(1),
    cons = ternary_node:named_child(0),
    alt = ternary_node:named_child(2),
  }

  return target_nodes
end

function M.recombination(target_nodes, buf)
  local cond_texts = utils.get_buf_texts_by_node(buf, target_nodes.cond)
  local cons_texts = utils.get_buf_texts_by_node(buf, target_nodes.cons)
  local alt_texts = utils.get_buf_texts_by_node(buf, target_nodes.alt)

  return utils.merge_texts({ alt_texts, { " if " }, cond_texts, { " else " }, cons_texts })
end

return M
