-- luacheck: globals vim
local common = require("swap-ternary.node-processor.common")

--- @type NodeProcessor
--- @diagnostic disable-next-line: missing-fields
local M = {}

function M.find_ternary_node_at_cursor(node_tree)
  return common.find_node_at_cursor(node_tree, "ternary_expression")
end

function M.get_target_nodes(ternary_node)
  local target_nodes = {
    cond = ternary_node:named_child(0),
    cons = ternary_node:named_child(1),
    alt = ternary_node:named_child(2),
  }
  return target_nodes
end

function M.recombination(target_nodes, buf)
  return common.recombination(target_nodes, buf)
end

return M
