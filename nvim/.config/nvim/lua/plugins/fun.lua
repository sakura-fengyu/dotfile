return {
	"Eandrju/cellular-automaton.nvim",
	lazy = false,
	-- keys = "<leader>cc",
	config = function()
		vim.keymap.set("n", "<leader>cc", "<cmd>CellularAutomaton make_it_rain<CR>")
	end,
}
