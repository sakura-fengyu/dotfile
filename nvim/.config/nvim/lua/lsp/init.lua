-- load lsp server configuration
require("lsp.servers.lua_ls")
require("lsp.servers.gopls")
require("lsp.servers.pyright")
require("lsp.servers.bashls")
require("lsp.servers.clangd")
require("lsp.servers.cmake")
require("lsp.servers.rust_analyzer")
require("lsp.servers.taplo")

-- LSP install
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		-- LSP
		"lua_ls",
		"gopls",
		"pyright",
		"bashls",
		"clangd",
		"cmake",
		"rust_analyzer",
		"taplo", -- For TOML files
	},
	automatic_enable = true,
})

-- Create LspInfo cmd
vim.api.nvim_create_user_command("LspInfo", ':checkhealth vim.lsp', {})

-- Configure diagnostics
vim.diagnostic.config({
	underline = true,
	virtual_text = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.HINT] = "⚑",
			[vim.diagnostic.severity.INFO] = "»"
		},
	},
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "none", -- Changed from "rounded" to "none"
		source = "if_many",
		header = "",
		prefix = "",
	},
})

-- Set up CursorHold autocommand to show diagnostics on hover
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float({
			focusable = false,
			close_events = {
				"BufLeave",
				"CursorMoved",
				"InsertEnter",
				"FocusLost"
			},
			border = "none", -- Changed from "rounded" to "none"
			source = "if_many",
			prefix = "",
		})
	end
})


-- Format on save
local format_on_save_filetypes = {
	json = true,
	go = true,
	lua = true,
	html = true,
	css = true,
	javascript = true,
	typescript = true,
	typescriptreact = true,
	c = true,
	cpp = true,
	objc = true,
	objcpp = true,
	dockerfile = true,
	terraform = false,
	tex = true,
	toml = true,
	prisma = true,
	rust = true,
}
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local ft = vim.bo.filetype
		if format_on_save_filetypes[ft] then
			local lineno = vim.api.nvim_win_get_cursor(0)
			vim.lsp.buf.format({ async = false })
			pcall(vim.api.nvim_win_set_cursor, 0, lineno)
		end
	end
})

-- Set up LspAttach autocmd for per-buffer configuration
vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		-- Set up per-buffer keymaps
		local ok, err = pcall(require('lsp.keymaps').setup, event.buf)
		if not ok then
			vim.notify("Failed to set up LSP keymaps: " .. tostring(err), vim.log.levels.WARN)
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client == nil then
			return
		end

		-- inlay hints
		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
		end

		-- highlight word
		if client:supports_method("textDocument/documentHighlight") then
			local autocmd = vim.api.nvim_create_autocmd
			local augroup = vim.api.nvim_create_augroup('lsp_highlight', { clear = false })

			vim.api.nvim_clear_autocmds({ buffer = event.buf, group = augroup })

			autocmd({ "CursorHold", "CursorHoldI" }, {
				group = augroup,
				buffer = event.buf,
				callback = vim.lsp.buf.document_highlight,
			})

			autocmd({ "CursorMoved", "CursorMovedI" }, {
				group = augroup,
				buffer = event.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end
})
