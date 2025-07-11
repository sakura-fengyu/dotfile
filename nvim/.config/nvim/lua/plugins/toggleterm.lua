return {
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = "<leader>'", -- the mapping to use to open the terminal
				hide_numbers = true, -- hide the number column in toggleterm buffers
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = "1", -- the degree by which to darken to terminal colour, default: -30
				start_in_insert = true,
				insert_mappings = false, -- whether or not the open mapping applies in insert mode
				terminal_mapping = true, -- whether or not the open mapping applies in terminal mode
				persist_size = true,
				direction = "float",
				close_on_exit = true, -- close the terminal window when the process exits
				shell = vim.o.shell, -- change the default shell
			})
		end
	}
}
