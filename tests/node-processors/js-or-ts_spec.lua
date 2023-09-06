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
      texts = { 'true ? "1111" : "aaa" || "bbb"' },
    },
    target_nodes = {
      cond = {
        texts = { "true" },
        range = { 0, 10, 0, 14 },
      },
      cons = {
        texts = { '"1111"' },
        range = { 0, 17, 0, 23 },
      },
      alt = {
        texts = { '"aaa" || "bbb"' },
        range = { 0, 26, 0, 40 },
      },
    },
    recomposed_texts = { 'true ? "aaa" || "bbb" : "1111"' },
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
      texts = { 'true ? "3333" : (false ? "eee" : "fff") && "ggg"' },
      range = { 0, 10, 0, 58 },
    },
    target_nodes = {
      cond = {
        texts = { "true" },
        range = { 0, 10, 0, 14 },
      },
      cons = {
        texts = { '"3333"' },
        range = { 0, 17, 0, 23 },
      },
      alt = {
        texts = { '(false ? "eee" : "fff") && "ggg"' },
        range = { 0, 26, 0, 58 },
      },
    },
    recomposed_texts = { 'true ? (false ? "eee" : "fff") && "ggg" : "3333"' },
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
      texts = { 'false ? "eee" : "fff"' },
      range = { 0, 27, 0, 48 },
    },
    target_nodes = {
      cond = {
        texts = { "false" },
        range = { 0, 27, 0, 32 },
      },
      cons = {
        texts = { '"eee"' },
        range = { 0, 35, 0, 40 },
      },
      alt = {
        texts = { '"fff"' },
        range = { 0, 43, 0, 48 },
      },
    },
    recomposed_texts = { 'false ? "fff" : "eee"' },
  },
  {
    file_type = "javascriptreact",
    code = string.format(
      [[
      const JSX = opened %s? <div>opened</div> : <div>closed</div>;
    ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      texts = { "opened ? <div>opened</div> : <div>closed</div>" },
      range = { 0, 18, 0, 64 },
    },
    target_nodes = {
      cond = {
        texts = { "opened" },
        range = { 0, 18, 0, 24 },
      },
      cons = {
        texts = { "<div>opened</div>" },
        range = { 0, 27, 0, 44 },
      },
      alt = {
        texts = { "<div>closed</div>" },
        range = { 0, 47, 0, 64 },
      },
    },
    recomposed_texts = { "opened ? <div>closed</div> : <div>opened</div>" },
  },
  {
    file_type = "typescript",
    code = string.format(
      [[
    let str: string | null = window.%sname ? window.name + "--xlboy--" : null;
    ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      texts = { 'window.name ? window.name + "--xlboy--" : null' },
      range = { 0, 29, 0, 75 },
    },
    target_nodes = {
      cond = {
        texts = { "window.name" },
        range = { 0, 29, 0, 40 },
      },
      cons = {
        texts = { 'window.name + "--xlboy--"' },
        range = { 0, 43, 0, 68 },
      },
      alt = {
        texts = { "null" },
        range = { 0, 71, 0, 75 },
      },
    },
    recomposed_texts = { 'window.name ? null : window.name + "--xlboy--"' },
  },
  {
    file_type = "typescriptreact",
    code = string.format(
      [[
    const jsx: JSX.Element | null = opened %s? <div>
      opened
      </div> : null;
    ]],
      common.constants.CURSOR_EMOJI
    ),
    ternary_node = {
      texts = { "opened ? <div>", "      opened", "      </div> : null" },
      range = { 0, 36, 2, 19 },
    },
    target_nodes = {
      cond = {
        texts = { "opened" },
        range = { 0, 36, 0, 42 },
      },
      cons = {
        texts = { "<div>", "      opened", "      </div>" },
        range = { 0, 45, 2, 12 },
      },
      alt = {
        texts = { "null" },
        range = { 2, 15, 2, 19 },
      },
    },
    recomposed_texts = { "opened ? null : <div>", "      opened", "      </div>" },
  },
})

common.test_processor(processor, test_sources)
