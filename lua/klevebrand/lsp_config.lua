local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local cmp = require('cmp')
local luasnip = require('luasnip')
local dap = require("dap")
local dapui = require("dapui")

-- ===================================
-- LSP Configuration Functions
-- ===================================

local capabilities = cmp_nvim_lsp.default_capabilities()

local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
end

-- ===================================
-- DAP Configuration for C#
-- ===================================
dap.adapters.cs = {
	type = 'executable',
	command = 'netcoredbg',
	args = {'--interpreter=vscode'},
}

dap.configurations.cs = {
	{
		type = 'cs',
		name = 'Launch .NET Core',
		request = 'launch',
		program = function()
			-- Get the current working directory
			local cwd = vim.fn.getcwd()

			-- Extract the project name from the directory path
			local project_name = vim.fn.fnamemodify(cwd, ':t')

			-- Construct the path to the compiled DLL dynamically
			local dll_path = string.format('%s/bin/Debug/net9.0/%s.dll', cwd, project_name)

			-- Prompt the user to confirm the path
			return vim.fn.input('Path to DLL: ', dll_path, 'file')
		end,
		cwd = '${workspaceFolder}',
		console = 'internalConsole',
	},
}

-- This configures nvim-dap-ui to open automatically when a debug session starts.
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
-- This closes the UI when the debug session is terminated.
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end

-- ===================================
-- Setup Language Servers
-- ===================================

-- Rust Analyzer
lspconfig.rust_analyzer.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}

-- Clangd for C/C++
lspconfig.clangd.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}

-- C#
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

