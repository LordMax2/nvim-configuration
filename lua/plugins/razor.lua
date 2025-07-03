return {
    "tris203/rzls.nvim", 
    ft = { "razor", "cshtml" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("rzls").setup()
    end,
}
