return {
	"Saghen/blink.cmp",
	event = { "BufReadPost", "BufNewFile" },
	-- version = "1.*",
	build = "cargo build --release",
	opts = {},
}
