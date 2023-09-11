local processor = require("swap-ternary.node-processor.python")
local common = require("tests.node-processors.common")

local test_sources = common.define_test_sources({
  {
    file_type = "python",
    code = string.format(
      [[
a = "1111" if True %s else "aaa" or "bbb"
      ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      range = { 0, 4, 0, 39 },
      texts = { '"1111" if True  else "aaa" or "bbb"' },
    },
    target_nodes = {
      cond = {
        texts = { "True" },
        range = { 0, 14, 0, 18 },
      },
      cons = {
        texts = { '"1111"' },
        range = { 0, 4, 0, 10 },
      },
      alt = {
        texts = { '"aaa" or "bbb"' },
        range = { 0, 25, 0, 39 },
      },
    },
    recomposed_texts = { '"aaa" or "bbb" if True else "1111"' },
  },
  {
    file_type = "python",
    code = string.format(
      [[
a = "1111" if True else "aaa" if True %s else "bbb"
      ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      range = { 0, 24, 0, 49 },
      texts = { '"aaa" if True  else "bbb"' },
    },
    target_nodes = {
      cond = {
        texts = { "True" },
        range = { 0, 33, 0, 37 },
      },
      cons = {
        texts = { '"aaa"' },
        range = { 0, 24, 0, 29 },
      },
      alt = {
        texts = { '"bbb"' },
        range = { 0, 44, 0, 49 },
      },
    },
    recomposed_texts = { '"bbb" if True else "aaa"' },
  },
  {
    file_type = "python",
    code = string.format(
      [[
a = "1111" if True
%s else
"bbb" if True else "ccc"
      ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      range = { 0, 4, 2, 24 },
      texts = { '"1111" if True', " else", '"bbb" if True else "ccc"' },
    },
    target_nodes = {
      cond = {
        texts = { "True" },
        range = { 0, 14, 0, 18 },
      },
      cons = {
        texts = { '"1111"' },
        range = { 0, 4, 0, 10 },
      },
      alt = {
        texts = { '"bbb" if True else "ccc"' },
        range = { 2, 0, 2, 24 },
      },
    },
    recomposed_texts = { '"bbb" if True else "ccc" if True else "1111"' },
  },
})

common.test_processor(processor, test_sources)
