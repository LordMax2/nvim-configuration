-- Treesitter setup
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "rust", "c", "lua", "vim", "vimdoc", "query",
    "markdown", "markdown_inline", "c_sharp"
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
}
