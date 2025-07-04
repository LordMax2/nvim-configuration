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

-- html lsp
lspconfig.html.setup({
	capabilities = require('cmp_nvim_lsp').default_capabilities(), -- optional for nvim-cmp
	filetypes = { "html", "htmldjango" }, -- add more as needed
})

-- rust-analyzer
lspconfig.rust_analyzer.setup {
	capabilities = cmp_nvim_lsp.default_capabilities(),
	on_attach = on_attach,
}

-- Razzmatazz csharp-ls for C#
lspconfig.csharp_ls.setup {
	cmd = { "csharp-ls" }, -- assumes it's in your PATH
	filetypes = { "cs" },
	capabilities = cmp_nvim_lsp.default_capabilities(),
	on_attach = on_attach,
	root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", ".git"),
}

lspconfig.clangd.setup {
	capabilities = cmp_nvim_lsp.default_capabilities(),
	on_attach = on_attach,
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
local capabilities = require('cmp_nvim_lsp').default_capabilities()
