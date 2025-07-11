local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- 查询nvim启动耗时 command :StartupTime
	{ "dstein64/vim-startuptime" },

	require("plugins.last-replace"),

	-- surround ys ds cs
	require("plugins.surround"),
	require("plugins.bullets"),

	require("plugins.behavior"),

	-- 文件浏览器
	require("plugins.yazi"),

	-- 语言服务管理器
	require("plugins.mason"),

	require("plugins.copilot"),

	require("plugins.completion"),

	require("plugins.telescope"),

	require("plugins.editor"),

	require("plugins.git"),

	require("plugins.indent"),

	require("plugins.undo"),

	require("plugins.yank"),

	-- require("config.plugins.treesitter"),

	require("plugins.fun"),

	require("plugins.markdown"),

	-- require("plugins.lspsaga"),

	require("plugins.toggleterm"),
})
