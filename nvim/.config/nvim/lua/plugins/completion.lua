return {
	"Saghen/blink.cmp",
	dependencies = { 'rafamadriz/friendly-snippets' },
	event = { "BufReadPost", "BufNewFile" },
	version = "1.*",
	-- build = "cargo build --release",
	opts = {
		keymap = {
			preset = "default",

			['<C-j>'] = { 'select_next', 'fallback' },
			['<C-k>'] = { 'select_prev', 'fallback' },
			['<Tab>'] = { 'select_and_accept', 'fallback' },
			['<C-e>'] = { 'select_and_accept', 'fallback' },
			['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },

	},
}
