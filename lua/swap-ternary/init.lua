-- luacheck: globals vim

--- @alias TernaryNode TSNode
--- @class TargetNodes
--- @field cond TSNode | nil
--- @field cons TSNode | nil
--- @field alt TSNode | nil

--- @class NodeProcessor
--- @field find_ternary_node_at_cursor fun(node_tree: LanguageTree): TernaryNode | nil
--- @field get_target_nodes fun(ternary_node: TernaryNode): TargetNodes
--- @field recombination fun(target_nodes: TargetNodes, buf: integer): string[]

local M = {}

function M.start()
  require("swap-ternary.controller").start()
end

return M
