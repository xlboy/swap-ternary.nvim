-- luacheck: globals vim

local M = {}

--- @type table<string, fun(type: string): boolean>
local file_type = {
  is_ts_or_js = function(type)
    return string.match(type, "typescript") or string.match(type, "javascript")
  end,
  is_c_or_cpp = function(type)
    return string.match(type, "cpp") or string.match(type, "c++") or string.match(type, "c")
  end,
  is_python = function(type)
    return string.match(type, "python")
  end,
  is_java = function(type)
    return string.match(type, "java")
  end,
  is_c_sharp = function(type)
    return string.match(type, "cs")
  end,
  is_dart = function(type)
    return string.match(type, "dart")
  end,
}

---@return NodeProcessor
local function get_node_processor(buf)
  local _file_type = vim.api.nvim_buf_get_option(buf, "filetype") ---@type string
  if file_type.is_ts_or_js(_file_type) then
    return require("swap-ternary.node-processor.js-or-ts")
  end
  if file_type.is_c_or_cpp(_file_type) then
    return require("swap-ternary.node-processor.c-or-cpp")
  end
  if file_type.is_python(_file_type) then
    return require("swap-ternary.node-processor.python")
  end
  if file_type.is_java(_file_type) then
    return require("swap-ternary.node-processor.java")
  end
  if file_type.is_c_sharp(_file_type) then
    return require("swap-ternary.node-processor.c#")
  end
  if file_type.is_dart(_file_type) then
    return require("swap-ternary.node-processor.dart")
  end
end

function M.swap()
  local current_buf = vim.api.nvim_get_current_buf()

  local node_tree = vim.treesitter.get_parser(current_buf)
  if not node_tree then
    return vim.notify("[swap-ternary] Node tree is empty or parser is missing for current buffer", vim.log.levels.ERROR)
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

  local recomposed_texts = node_processor.recombination(target_nodes, current_buf)
  --- `t_n_s` = `ternary_node_start`, `t_n_e` = `ternary_node_end`
  local t_n_s_line, t_n_s_col, t_n_e_line, t_n_e_col = ternary_node:range()
  vim.api.nvim_buf_set_text(current_buf, t_n_s_line, t_n_s_col, t_n_e_line, t_n_e_col, recomposed_texts)
end

return M
