return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			-- Define configuration overrides for servers
			vim.lsp.config('gopls', {})
			vim.lsp.config('htmx', {})
			vim.lsp.config('tailwindcss', {})
			vim.lsp.config('ts_ls', {})
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

			-- Enable the LSP servers
			vim.lsp.enable({ 'gopls', 'htmx', 'tailwindcss', 'lua_ls', 'ts_ls' })

			-- Set up LSP Attach Autocommand for buffer-local settings
			vim.api.nvim_create_autocmd('LspAttach', {
				desc = 'LSP actions and keybindings',
				callback = function(event)
					local opts = { buffer = event.buf }

					-- ℹ️ Information (Details dekhne ke liye)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = "Hover Documentation" }))
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = "Signature Help (Parameters)" }))

					-- 🛠️ Refactoring & Actions (Code change karne ke liye)
					vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = "Rename Variable/Function" }))
					vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = "Code Actions (Fixes)" }))
					vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, vim.tbl_extend('force', opts, { desc = "Format Code" }))

					-- 🚨 Diagnostics (Errors aur Warnings ke liye)
					vim.keymap.set('n', 'gl', vim.diagnostic.open_float, vim.tbl_extend('force', opts, { desc = "Show Line Diagnostics (Error message)" }))
					vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = "Go to Previous Error/Warning" }))
					vim.keymap.set('n', ']d', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = "Go to Next Error/Warning" }))

					-- Get client for capabilities checking
					local client = vim.lsp.get_client_by_id(event.data.client_id)

					-- 📍 Inlay Hints (Native support in Neovim 0.10+)
					if client and client.supports_method('textDocument/inlayHint') then
						vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
					end

					-- 📍 Document highlighting (under cursor reference highlighting)
					if client and client.supports_method('textDocument/documentHighlight') then
						local highlight_group = vim.api.nvim_create_augroup('lsp_document_highlight_' .. event.buf, { clear = true })
						vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
							group = highlight_group,
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
							group = highlight_group,
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})
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
	}
}
