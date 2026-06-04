return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			vim.lsp.config('gopls',{})
			vim.lsp.config('htmx',{})
			vim.lsp.config('tailwindcss',{})
			vim.lsp.config('lua_ls', {
				settings = {
					Lua = {
						runtime = {
							version = 'LuaJIT',
						},
						diagnostics = {
							globals = {
								'vim',
								'require'
							},
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			-- ==========================================
			-- 🚀 Advanced LSP Keybindings
			-- ==========================================

			-- 📍 Navigation (Code mein ghoomne ke liye)
			-- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to Declaration" })
			-- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
			-- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "Go to Implementation" })
			-- vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Show all References" })
      -- above once are shifted to snacks.nvim plugin 


			-- ℹ️ Information (Details dekhne ke liye)
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover Documentation" })
			vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = "Signature Help (Parameters)" })

			-- 🛠️ Refactoring & Actions (Code change karne ke liye)
			vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename Variable/Function" })
			vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = "Code Actions (Fixes)" })
			vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, { desc = "Format Code" })

			-- 🚨 Diagnostics (Errors aur Warnings ke liye)
			vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Show Line Diagnostics (Error message)" })
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to Previous Error/Warning" })
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to Next Error/Warning" })
		end
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"stylua",
				"gopls",
				"ts_ls",
				"htmx",
				"tailwindcss",
			}
		}
	},
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
	},
	{
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    config = function()
      require("inlay-hints").setup()
    end,
  }
}
