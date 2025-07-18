local M = {}

function M.setup(bufnr)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP:Go to definition" })
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "LSP:Go to declaration" })
	vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = bufnr, desc = "LSP:Format" })
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP:Rename" })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP:Rename" })

	-- Diagnostics
	vim.keymap.set('n', '<leader>-', function() vim.diagnostic.jump({ count = -1 }) end, opts)
	vim.keymap.set('n', '<leader>=', function() vim.diagnostic.jump({ count = 1 }) end, opts)
	vim.keymap.set('n', '<leader>t', ':Trouble<cr>', opts)
	-- vim.keymap.set("n", "<c-space>", "<c-x><c-o>", { buffer = bufnr, desc = "LSP:Completion" })
	-- vim.keymap.set('i', '<Tab>', tab_complete, { expr = true })
	-- vim.keymap.set('i', '<S-Tab>', tab_prev, { expr = true })
end

return M
