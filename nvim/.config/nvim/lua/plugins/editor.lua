return {
	--
	{
		"rmagatti/goto-preview",
		dependencies = { "rmagatti/logger.nvim" },
		event = "BufEnter",
		config = function()
			vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
				{ noremap = true })
			require("goto-preview").setup({
				-- nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
				-- nnoremap gpt <cmd>lua require('goto-preview').goto_preview_type_definition()<CR>
				-- nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
				-- nnoremap gpD <cmd>lua require('goto-preview').goto_preview_declaration()<CR>
				-- nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>
				-- nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>
				default_mappings = False, -- UnBind default mappings
				debug = false, -- Print debug information
				width = 120, -- Width of the floating window
				height = 15, -- Height of the floating window
				border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters
				opacity = nil, -- Opacity of the floating window (0-100)
			})
		end,
	},

	-- autoPairs
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},

	-- 自动化符号列表
	{
		"dkarter/bullets.vim", -- Bullets.vim is a Vim plugin for automated bullet lists.
		lazy = false,
		ft = { "markdown", "txt" },
	},

	{ 'gcmt/wildfire.vim', lazy = false, }, --	Press enter select block

	-- A high-performance color highlighter
	{
		"atgoose/nvim-colorizer.lua",
		event = { "VeryLazy" },
		opts = {
			lazy_load = true,
		},
	},

	-- 行、块移动
	{
		"fedepujol/move.nvim", -- A Neovim plugin to move lines and blocks of text up and down.
		config = function()
			require('move').setup({
				line = {
					enable = true,
					indent = true
				},
				block = {
					enable = true,
					indent = true
				},
				word = {
					enable = false,
				},
				char = {
					enable = false
				}
			})
			local opts = { noremap = true, silent = true }
			-- Normal-mode commands
			vim.keymap.set('n', '<c-s-j>', ':MoveLine(1)<CR>', opts)
			vim.keymap.set('n', '<c-s-k>', ':MoveLine(-1)<CR>', opts)

			-- Visual-mode commands
			vim.keymap.set('v', '<c-s-j>', ':MoveBlock(1)<CR>', opts)
			vim.keymap.set('v', '<c-s-k>', ':MoveBlock(-1)<CR>', opts)
		end
	},
}
