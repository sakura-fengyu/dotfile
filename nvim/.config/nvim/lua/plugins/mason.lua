return {
	{
		"mason-org/mason.nvim",
		event = { "BufReadPost", "BufNewFile", "VimEnter" },
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗"
				}
			}
		},
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"lua_ls",
				"gopls",
				"pyright",
				"bashls",
				"clangd",
				"cmake",
				"rust_analyzer",
				"taplo", -- For TOML files
				-- "tsserver",
				-- "html",
				-- "cssls",
				-- "jsonls",
				-- "dockerls",
				-- "rust_analyzer"
			}
		}
	}
}
