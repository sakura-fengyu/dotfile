---@brief
---
--- https://taplo.tamasfe.dev/cli/usage/language-server.html
---
--- Language server for Taplo, a TOML toolkit.
---
--- `taplo-cli` can be installed via `cargo`:
--- ```sh
--- cargo install --features lsp --locked taplo-cli
--- ```
local taplo_config = {
	cmd = { 'taplo', 'lsp', 'stdio' },
	filetypes = { 'toml' },
	root_markers = { '.taplo.toml', 'taplo.toml', '.git' },
}

return {
	vim.lsp.config("taplo", taplo_config),
	vim.lsp.enable("taplo")
}
