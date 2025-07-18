local lua_ls_config = {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					'lua/?.lua',
					'lua/?/init.lua',
				},
			},
			-- Make the server aware of Neovim runtime files
			checkThirdParty = false,
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					-- "~/.config/nvim/",
					"~/dotfile/nvim/.config/nvim",
					vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
					-- Depending on the usage, you might want to add additional paths
					-- here.
					'${3rd}/luv/library'
					-- '${3rd}/busted/library'
				},
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			},
		})
	end,
	settings = {
		Lua = {},
	},
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
}

return {
	vim.lsp.config("lua_ls", lua_ls_config),
	vim.lsp.enable("lua_ls")
}
