local processor = require("swap-ternary.node-processor.js-or-ts")
local common = require("tests.node-processors.common")

local test_sources = common.define_test_sources({
  {
    file_type = "javascript",
    code = string.format(
      [[
const a = true ? "1111" %s: "aaa" || "bbb"
      ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      range = { 0, 10, 0, 40 },
      text = 'true ? "1111" : "aaa" || "bbb"',
    },
    target_nodes = {
      cond = {
        text = "true",
        range = { 0, 10, 0, 14 },
      },
      cons = {
        text = '"1111"',
        range = { 0, 17, 0, 23 },
      },
      alt = {
        text = '"aaa" || "bbb"',
        range = { 0, 26, 0, 40 },
      },
    },
    recomposed_text = 'true ? "aaa" || "bbb" : "1111"',
  },
  {
    file_type = "javascript",
    code = string.format(
      [[
const c = true ? "3333" %s: (false ? "eee" : "fff") && "ggg"
      ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      text = 'true ? "3333" : (false ? "eee" : "fff") && "ggg"',
      range = { 0, 10, 0, 58 },
    },
    target_nodes = {
      cond = {
        text = "true",
        range = { 0, 10, 0, 14 },
      },
      cons = {
        text = '"3333"',
        range = { 0, 17, 0, 23 },
      },
      alt = {
        text = '(false ? "eee" : "fff") && "ggg"',
        range = { 0, 26, 0, 58 },
      },
    },
    recomposed_text = 'true ? (false ? "eee" : "fff") && "ggg" : "3333"',
  },
  {
    file_type = "javascript",
    code = string.format(
      [[
const c = true ? "3333" : (%sfalse ? "eee" : "fff") && "ggg"
      ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      text = 'false ? "eee" : "fff"',
      range = { 0, 27, 0, 48 },
    },
    target_nodes = {
      cond = {
        text = "false",
        range = { 0, 27, 0, 32 },
      },
      cons = {
        text = '"eee"',
        range = { 0, 35, 0, 40 },
      },
      alt = {
        text = '"fff"',
        range = { 0, 43, 0, 48 },
      },
    },
    recomposed_text = 'false ? "fff" : "eee"',
  },
})

common.test_processor(processor, test_sources)
