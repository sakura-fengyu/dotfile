return {
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		-- For `nvim-treesitter` users.
		priority = 49,
	},

	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup({
				app = { "Google Chrome", '--new-window' },
			})
			vim.api.nvim_create_user_command("MarkdownPreview", require("peek").open, {})
			vim.api.nvim_create_user_command("MarkDownPreviewClose", require("peek").close, {})
		end,
	},

};
