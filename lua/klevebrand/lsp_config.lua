local cmp = require('cmp')
local luasnip = require('luasnip')

-- Setup LSPs
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Common on_attach for all LSPs
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
end

-- rust-analyzer
lspconfig.rust_analyzer.setup {
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
}
vim.lsp.config("roslyn", {
    on_attach = function()
        print("This will run when the server attaches!")
    end,
    settings = {
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
        },
    },
})

-- Razzmatazz csharp-ls for C#
lspconfig.csharp_ls.setup {
  cmd = { "csharp-ls" }, -- assumes it's in your PATH
  filetypes = { "cs" },
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", ".git"),
}

lspconfig.rzls.setup {
  cmd = { "rzls" }, -- or full path to binary if not in PATH
  filetypes = { "razor", "cshtml" },
  root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", ".git"),
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  end,
}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.cshtml", "*.razor" },
  callback = function()
    vim.bo.filetype = "razor"
  end,
})

-- Setup nvim-cmp and luasnip
local cmp = require('cmp')
local luasnip = require('luasnip')
