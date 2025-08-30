-- ===================================
-- Required Modules
-- ===================================
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local cmp = require('cmp')
local luasnip = require('luasnip')

-- ===================================
-- LSP Configuration Functions
-- ===================================
local dap = require("dap")
local dapui = require("dapui")

-- Common capabilities for nvim-cmp
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Common on_attach function for keymaps
local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    -- You can add more common keymaps here, like for code actions
    -- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    -- Attach DAP to this client if it supports debugging
    if client.name == "omnisharp" then
        require("csharp.dap").setup()
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
    end
end

-- ===================================
-- Setup Language Servers
-- ===================================

-- HTML LSP
lspconfig.html.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "html", "htmldjango" },
})

-- Rust Analyzer
lspconfig.rust_analyzer.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

-- OmniSharp for C#
-- This is a more robust alternative to csharp_ls
lspconfig.omnisharp.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "cs", "vb", ".razor" },
    root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", "OmniSharp.json"),
    -- Example of adding custom settings to OmniSharp
    -- settings = {
    --     EnableEditorConfigSupport = true,
    --     EnableImportCompletion = true,
    -- },
}

-- Clangd for C/C++
lspconfig.clangd.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

-- ===================================
-- Autocompletion Setup with nvim-cmp
-- ===================================

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

-- ===================================
-- Filetype Autocmds
-- ===================================

-- Set the filetype for Razor/CSHTML files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.cshtml", "*.razor" },
    callback = function()
        vim.bo.filetype = "razor"
    end,
})
