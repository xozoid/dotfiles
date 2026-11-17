local sources = require("snacks").config.picker.sources or {}
require("snacks").config.picker.sources = sources

for _, name in ipairs({ "explorer", "files", "grep" }) do
  local source = sources[name] or {}
  source.exclude = vim.list_extend(source.exclude or {}, { "zsh/ohmyzsh" })
  sources[name] = source
end
