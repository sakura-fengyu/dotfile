return {
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = false,
		branch = 'main',
		build = ':TSUpdate',
		init = function()
			local parser_installed = {
				"c",
				"python",
				"go",
				"typescript",
				"javascript",
				"lua",
				"vim",
				"vimdoc",
				"markdown_inline",
				"markdown",
			}
			require("nvim-treesitter").install(parser_installed)

			-- auto-start highlights & indentation
			vim.api.nvim_create_autocmd("FileType", {
				desc = "User: enable treesitter highlighting",
				callback = function(ctx)
					-- highlights
					local hasStarted = pcall(vim.treesitter.start) -- errors for filetypes with no parser

					-- folds
					if hasStarted then
						vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
					end

					-- indent
					local noIndent = {}
					if hasStarted and not vim.list_contains(noIndent, ctx.match) then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end
	}
}
