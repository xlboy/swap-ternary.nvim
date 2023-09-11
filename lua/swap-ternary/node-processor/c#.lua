-- luacheck: globals vim
local common = require("swap-ternary.node-processor.common")

--- @type NodeProcessor
--- @diagnostic disable-next-line: missing-fields
local M = {}

function M.find_ternary_node_at_cursor(node_tree)
  return common.find_node_at_cursor(node_tree, "conditional_expression")
end

function M.get_target_nodes(ternary_node)
  return common.get_target_nodes(ternary_node)
end

function M.recombination(target_nodes, buf)
  return common.recombination(target_nodes, buf)
end

return M
