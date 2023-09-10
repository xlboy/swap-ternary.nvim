local processor = require("swap-ternary.node-processor.c-or-cpp")
local common = require("tests.node-processors.common")

local function create_c_cpp_textures(ftype)
  return {
    {
      file_type = ftype,
      code = string.format(
        [[
true ? "1111" %s: "aaa" || "bbb";
        ]],
        common.constants.CURSOR_EMOJI
      ),
      ternary_node = {
        range = { 0, 0, 0, 30 },
        texts = { 'true ? "1111" : "aaa" || "bbb"' },
      },
      target_nodes = {
        cond = {
          texts = { "true" },
          range = { 0, 0, 0, 4 },
        },
        cons = {
          texts = { '"1111"' },
          range = { 0, 7, 0, 13 },
        },
        alt = {
          texts = { '"aaa" || "bbb"' },
          range = { 0, 16, 0, 30 },
        },
      },
      recomposed_texts = { 'true ? "aaa" || "bbb" : "1111"' },
    },
    {
      file_type = ftype,
      code = string.format(
        [[
true ? "3333" %s: (false ? "eee" : "fff") && "ggg";
        ]],
        common.constants.CURSOR_EMOJI
      ),
      ternary_node = {
        texts = { 'true ? "3333" : (false ? "eee" : "fff") && "ggg"' },
        range = { 0, 0, 0, 48 },
      },
      target_nodes = {
        cond = {
          texts = { "true" },
          range = { 0, 0, 0, 4 },
        },
        cons = {
          texts = { '"3333"' },
          range = { 0, 7, 0, 13 },
        },
        alt = {
          texts = { '(false ? "eee" : "fff") && "ggg"' },
          range = { 0, 16, 0, 48 },
        },
      },
      recomposed_texts = { 'true ? (false ? "eee" : "fff") && "ggg" : "3333"' },
    },
    {
      file_type = ftype,
      code = string.format(
        [[
true ? "3333" : (%sfalse ? "eee" : "fff") && "ggg";
        ]],
        common.constants.CURSOR_EMOJI
      ),
      ternary_node = {
        texts = { 'false ? "eee" : "fff"' },
        range = { 0, 17, 0, 38 },
      },
      target_nodes = {
        cond = {
          texts = { "false" },
          range = { 0, 17, 0, 22 },
        },
        cons = {
          texts = { '"eee"' },
          range = { 0, 25, 0, 30 },
        },
        alt = {
          texts = { '"fff"' },
          range = { 0, 33, 0, 38 },
        },
      },
      recomposed_texts = { 'false ? "fff" : "eee"' },
    },
  }
end

local c_test_sources = common.define_test_sources(create_c_cpp_textures("c"))
local cpp_test_sources = common.define_test_sources(create_c_cpp_textures("cpp"))

common.test_processor(processor, c_test_sources)
common.test_processor(processor, cpp_test_sources)
