return {
				"lewis6991/gitsigns.nvim",
				-- 'event' use karne se yeh plugin tabhi load hoga jab aap koi file open karenge,
				-- isse Neovim ka startup time fast rehta hai.
				event = { "BufReadPre", "BufNewFile" },

				opts = {
								signs = {
												add          = { text = '│' },
												change       = { text = '│' },
												delete       = { text = '_' },
												topdelete    = { text = '‾' },
												changedelete = { text = '~' },
												untracked    = { text = '┆' },
								},

								-- Current line par kisne code likha tha (Git Blame) dekhne ke liye isey true karein
								current_line_blame = true, 
								current_line_blame_opts = {
												delay = 500, -- Blame text 0.5 seconds ke baad dikhega
								},

								-- Shortcuts (Keymaps) setup karne ka function
								on_attach = function(bufnr)
												local gs = package.loaded.gitsigns

												local function map(mode, l, r, opts)
																opts = opts or {}
																opts.buffer = bufnr
																vim.keymap.set(mode, l, r, opts)
												end

												-- 📍 Navigation (Ek change se dusre change par jump karne ke liye)
												map('n', ']c', function()
																if vim.wo.diff then return ']c' end
																vim.schedule(function() gs.next_hunk() end)
																return '<Ignore>'
												end, {expr=true, desc="Next Git Hunk"})

												map('n', '[c', function()
																if vim.wo.diff then return '[c' end
																vim.schedule(function() gs.prev_hunk() end)
																return '<Ignore>'
												end, {expr=true, desc="Previous Git Hunk"})

												-- 🛠️ Actions (Changes ko stage/reset ya preview karne ke liye)
												map('n', '<leader>hs', gs.stage_hunk, {desc="Stage Hunk"})
												map('n', '<leader>hr', gs.reset_hunk, {desc="Reset Hunk"})
												map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc="Stage Selected Hunk"})
												map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc="Reset Selected Hunk"})

												map('n', '<leader>hp', gs.preview_hunk, {desc="Preview Hunk (Pop-up)"})
												map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc="Show Full Git Blame"})
												map('n', '<leader>td', gs.toggle_deleted, {desc="Toggle Deleted Lines"})
								end
				}
}
