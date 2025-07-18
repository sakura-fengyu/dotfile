return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep",
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
	},
	config = function()
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "sf", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "sw", builtin.live_grep, { desc = "Find files" })
		vim.keymap.set("n", "ss", builtin.resume, { desc = "Find files" })
		vim.keymap.set("n", "sg", builtin.grep_string, { desc = "Grep string" })
		vim.keymap.set("n", "sb", builtin.buffers, { desc = "List buffers" })
		vim.keymap.set('n', 'so', builtin.oldfiles, { desc = "Search old file" })
		vim.keymap.set("n", "st", builtin.help_tags, { desc = "Help tags" })
		vim.keymap.set("n", "sd", builtin.diagnostics, { desc = "Diagnositics" })
		vim.keymap.set("n", "<leader>:", builtin.commands, { desc = "Commands" })
		vim.keymap.set("n", "se", builtin.keymaps, { desc = "Keymaps" })
		vim.keymap.set("n", "sc", builtin.current_buffer_fuzzy_find, { desc = "" })
		-- vim.keymap.set("n", "sgs", builtin.git_status, { desc = "Search git status" })

		local telescope = require("telescope")
		telescope.setup({
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
					find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
					hidden = true,
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,    -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				}
			},
		})
		telescope.load_extension("fzf")
	end
}
