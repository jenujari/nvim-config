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
			-- emmylua_ls instead of lua_ls: upstream lua-language-server ships no
			-- musl build, so Mason can never install it here. Note the settings
			-- live under 'emmylua', not lua_ls's 'Lua'.
			vim.lsp.config('emmylua_ls', {
				on_init = function(client)
					-- Defer to a project's own Lua LS config when it has one.
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath('config')
							and (vim.uv.fs_stat(path .. '/.emmyrc.json') or vim.uv.fs_stat(path .. '/.luarc.json'))
						then
							client.config.settings = {}
						end
					end
				end,
				settings = {
					emmylua = {
						runtime = {
							version = 'LuaJIT',
						},
						diagnostics = {
							globals = {
								'vim',
							},
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
					},
				},
			})

			-- Enable the LSP servers
			vim.lsp.enable({ 'gopls', 'htmx', 'tailwindcss', 'emmylua_ls', 'ts_ls' })

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
					if client and client:supports_method('textDocument/inlayHint') then
						vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
					end

					-- 📍 Document highlighting (under cursor reference highlighting)
					if client and client:supports_method('textDocument/documentHighlight') then
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
				"emmylua_ls",
				"stylua",
				"gopls",
				"ts_ls",
				"htmx",
				"tailwindcss",
				"delve",
			}
		}
	},
	{
		"mason-org/mason.nvim",
		init = function()
			-- This is a musl system with libc++ instead of libstdc++, and Rust's
			-- musl target links the CRT statically by default. Mason's cargo
			-- packages that pull in a C++ scanner (htmx-lsp via tree-sitter-html)
			-- fail to link without both of these:
			--   CXXSTDLIB=c++            -> link libc++, not the absent libstdc++
			--   -C target-feature=-crt-static -> only libc++.so ships, no libc++.a
			-- musl's ldd writes to stderr, so probe for its loader instead.
			if #vim.fn.glob("/lib/ld-musl-*.so.1", false, true) > 0 then
				vim.env.CXXSTDLIB = vim.env.CXXSTDLIB or "c++"
				local flags = vim.env.RUSTFLAGS or ""
				if not flags:find("crt%-static") then
					vim.env.RUSTFLAGS = vim.trim(flags .. " -C target-feature=-crt-static")
				end
			end
		end,
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
	}
}
