return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	-- or                              , branch = '0.1.x',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "sf", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "sg", builtin.grep_string, { desc = "Grep string" })
		vim.keymap.set("n", "sb", builtin.buffers, { desc = "List buffers" })
		vim.keymap.set("n", "st", builtin.help_tags, { desc = "Help tags" })
		vim.keymap.set("n", "sd", builtin.diagnostics, { desc = "Diagnositics" })
		-- vim.keymap.set("n", "sgs", builtin.git_status, { desc = "Search git status" })
		vim.keymap.set("n", "<leader>:", builtin.commands, { desc = "Commands" })
		-- vim.keymap.set("n", "<c-k>", builtin.keymaps, { desc = "Keymaps" })
		-- vim.keymap.set("n", "s-", builtin.current_buffer_fuzzy_find, { desc = "" })

		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<C-u>"] = "results_scrolling_up",
						["<C-d>"] = "results_scrolling_down",
						["<C-n>"] = "preview_scrolling_down",
						["<C-p>"] = "preview_scrolling_up",
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
						["<esc>"] = "close",
					},
				},
				prompt_prefix = "🔍 ",
				selection_caret = "➜ ",
				entry_prefix = "  ",
				initial_mode = "insert",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.6,
					},
					vertical = {
						mirror = false,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
			extensions = {},
		})
	end
}
