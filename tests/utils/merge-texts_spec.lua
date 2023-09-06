local utils = require("swap-ternary.utils")

it("merge_texts", function()
  local texts = {
    { "line 1...", "line 2..." },
    { "oh really…" },
    { "another line", "another another line" },
  }
  local result = utils.merge_texts(texts)
  assert.are.same(result, { "line 1...", "line 2...oh really…another line", "another another line" })
end)
