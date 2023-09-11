local processor = require("swap-ternary.node-processor.java")
local common = require("tests.node-processors.common")

local test_sources = common.define_test_sources({
  {
    file_type = "java",
    code = string.format(
      [[
int max = (aaa > bbb%s) ? ccc : ddd;
      ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      range = { 0, 10, 0, 33 },
      texts = { "(aaa > bbb) ? ccc : ddd" },
    },
    target_nodes = {
      cond = {
        texts = { "(aaa > bbb)" },
        range = { 0, 10, 0, 21 },
      },
      cons = {
        texts = { "ccc" },
        range = { 0, 24, 0, 27 },
      },
      alt = {
        texts = { "ddd" },
        range = { 0, 30, 0, 33 },
      },
    },
    recomposed_texts = { "(aaa > bbb) ? ddd : ccc" },
  },
  {
    file_type = "java",
    code = string.format(
      [[
int max = (aaa > bbb) ? (ccc > ddd%s) ? eee : fff : ggg;
      ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      range = { 0, 24, 0, 47 },
      texts = { "(ccc > ddd) ? eee : fff" },
    },
    target_nodes = {
      cond = {
        texts = { "(ccc > ddd)" },
        range = { 0, 24, 0, 35 },
      },
      cons = {
        texts = { "eee" },
        range = { 0, 38, 0, 41 },
      },
      alt = {
        texts = { "fff" },
        range = { 0, 44, 0, 47 },
      },
    },
    recomposed_texts = { "(ccc > ddd) ? fff : eee" },
  },
  {
    file_type = "java",
    code = string.format(
      [[
int max = (aaa > bbb) ?
  (ccc > ddd%s) ?
    eee :
    fff :
  ggg;
      ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      range = { 1, 2, 3, 7 },
      texts = { "(ccc > ddd) ?", "    eee :", "    fff" },
    },
    target_nodes = {
      cond = {
        texts = { "(ccc > ddd)" },
        range = { 1, 2, 1, 13 },
      },
      cons = {
        texts = { "eee" },
        range = { 2, 4, 2, 7 },
      },
      alt = {
        texts = { "fff" },
        range = { 3, 4, 3, 7 },
      },
    },
    recomposed_texts = { "(ccc > ddd) ? fff : eee" },
  },
})

common.test_processor(processor, test_sources)
