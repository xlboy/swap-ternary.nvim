local processor = require("swap-ternary.node-processor.c#")
local common = require("tests.node-processors.common")

local test_sources = common.define_test_sources({
  {
    file_type = "cs",
    code = string.format(
      [[
string result = (10 > 5) ? "%s111" : "2222"
      ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      range = { 0, 16, 0, 41 },
      texts = { '(10 > 5) ? "111" : "2222"' },
    },
    target_nodes = {
      cond = {
        texts = { "(10 > 5)" },
        range = { 0, 16, 0, 24 },
      },
      cons = {
        texts = { '"111"' },
        range = { 0, 27, 0, 32 },
      },
      alt = {
        texts = { '"2222"' },
        range = { 0, 35, 0, 41 },
      },
    },
    recomposed_texts = { '(10 > 5) ? "2222" : "111"' },
  },
  {
    file_type = "cs",
    code = string.format(
      [[
string result = (10 > 5) ? "111" : (-77 > 6%s) ? "2222" : "3333"
      ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      range = { 0, 35, 0, 62 },
      texts = { '(-77 > 6) ? "2222" : "3333"' },
    },
    target_nodes = {
      cond = {
        texts = { "(-77 > 6)" },
        range = { 0, 35, 0, 44 },
      },
      cons = {
        texts = { '"2222"' },
        range = { 0, 47, 0, 53 },
      },
      alt = {
        texts = { '"3333"' },
        range = { 0, 56, 0, 62 },
      },
    },
    recomposed_texts = { '(-77 > 6) ? "3333" : "2222"' },
  },
  {
    file_type = "cs",
    code = string.format(
      [[
string result = (10 > 5) ? "111" : (-77 > 6%s)
  ? "2222"
  : "3333"
      ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      range = { 0, 35, 2, 10 },
      texts = { "(-77 > 6)", '  ? "2222"', '  : "3333"' },
    },
    target_nodes = {
      cond = {
        texts = { "(-77 > 6)" },
        range = { 0, 35, 0, 44 },
      },
      cons = {
        texts = { '"2222"' },
        range = { 1, 4, 1, 10 },
      },
      alt = {
        texts = { '"3333"' },
        range = { 2, 4, 2, 10 },
      },
    },
    recomposed_texts = { '(-77 > 6) ? "3333" : "2222"' },
  },
})

common.test_processor(processor, test_sources)
