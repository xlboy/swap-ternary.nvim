--- @class NodeInfo
--- @field range { integer, integer, integer, integer }
--- @field texts string[]

--- @class TestSource
--- @field file_type "javascript" | "javascriptreact" | "typescript" | "typescriptreact" | "c" | "cpp" | "python" | "java" | "cs" | "dart" | "swift" | "ruby"
--- @field code string
--- @field ternary_node NodeInfo
--- @field target_nodes { alt: NodeInfo, cond: NodeInfo, cons: NodeInfo }
--- @field recomposed_texts string[]

local get_buf_texts_by_node = require("swap-ternary.utils").get_buf_texts_by_node

local M = {
  constants = { CURSOR_EMOJI = "✍" },
}

local utils = {
  find_substr_pos = function(text, substr)
    -- Initialize line and column counters
    local line_num = 1
    local col_num = 1

    -- Index start point
    local start_index = 1

    -- Continue finding until no more substr
    while true do
      local start, finish = string.find(text, substr, start_index)

      -- If substr not found, break the loop
      if not start then
        break
      end

      -- Calculate line number and column number
      for i = start_index, start do
        local c = text:sub(i, i)

        -- Check if the character is a newline
        if c == "\n" then
          line_num = line_num + 1
          col_num = 1
        elseif i == start then
          return line_num, col_num
        end

        if c ~= "\n" then
          col_num = col_num + 1
        end
      end

      -- Update the start index for next search
      start_index = finish + 1
    end
  end,
}

local function init_test(code, file_type)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "filetype", file_type)
  vim.api.nvim_command("buffer " .. buf)
  local win = vim.api.nvim_get_current_win()

  local cursor_line, cursor_column = utils.find_substr_pos(code, M.constants.CURSOR_EMOJI)

  local normal_code = string.gsub(code, M.constants.CURSOR_EMOJI, "")

  local lines = {}
  for line in string.gmatch(normal_code, "(.-)\n") do
    table.insert(lines, line)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(win, { cursor_line, cursor_column })

  return win, buf
end

---@param sources TestSource[]
function M.define_test_sources(sources)
  return sources
end

---@param processor NodeProcessor
---@param test_sources TestSource[]
function M.test_processor(processor, test_sources)
  for _, value in ipairs(test_sources) do
    print("Testing " .. value.file_type .. " " .. value.code)
    local _, buf = init_test(value.code, value.file_type)
    local node_tree = vim.treesitter.get_parser(buf)
    local ternary_node = processor.find_ternary_node_at_cursor(node_tree)

    -- #region ternary_node
    assert.is.truthy(ternary_node)
    assert.are.same({ ternary_node:range() }, value.ternary_node.range)
    assert.are.same(get_buf_texts_by_node(buf, ternary_node), value.ternary_node.texts)
    -- #endregion ternary_node

    -- #region target_nodes
    local target_nodes = processor.get_target_nodes(ternary_node)

    assert.is.truthy(target_nodes.cond)
    assert.are.same({ target_nodes.cond:range() }, value.target_nodes.cond.range)
    assert.are.same(get_buf_texts_by_node(buf, target_nodes.cond), value.target_nodes.cond.texts)

    assert.is.truthy(target_nodes.cons)
    assert.are.same({ target_nodes.cons:range() }, value.target_nodes.cons.range)
    assert.are.same(get_buf_texts_by_node(buf, target_nodes.cons), value.target_nodes.cons.texts)

    assert.is.truthy(target_nodes.alt)
    assert.are.same({ target_nodes.alt:range() }, value.target_nodes.alt.range)
    assert.are.same(get_buf_texts_by_node(buf, target_nodes.alt), value.target_nodes.alt.texts)

    -- #endregion target_nodes

    assert.are.same(processor.recombination(target_nodes, buf), value.recomposed_texts)
  end
end

return M
