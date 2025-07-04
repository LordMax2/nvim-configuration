require("klevebrand.remap")

require('klevebrand.treesitter_config')

require('klevebrand.lsp_config')

vim.cmd.colorscheme "catppuccin"

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

