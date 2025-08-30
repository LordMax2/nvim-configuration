vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "LSP: Show diagnostics under cursor" })

-- Basic DAP keymaps
vim.keymap.set('n', '<F5>', '<cmd>DapContinue<CR>', { desc = "Continue/Start" })
vim.keymap.set('n', '<F10>', '<cmd>DapStepOver<CR>', { desc = "Step Over" })
vim.keymap.set('n', '<F11>', '<cmd>DapStepInto<CR>', { desc = "Step Into" })
vim.keymap.set('n', '<F12>', '<cmd>DapStepOut<CR>', { desc = "Step Out" })
vim.keymap.set('n', '<leader>b', '<cmd>DapToggleBreakpoint<CR>', { desc = "Toggle Breakpoint" })
vim.keymap.set('n', '<leader>B', '<cmd>DapToggleConditionalBreakpoint<CR>', { desc = "Toggle Conditional Breakpoint" })
