---@brief
---
--- https://github.com/regen100/cmake-language-server
---
--- CMake LSP Implementation
local cmake_config = {
	cmd = { 'cmake-language-server' },
	filetypes = { 'cmake' },
	root_markers = { 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake' },
	init_options = {
		buildDirectory = 'build',
	},
}

return {
	vim.lsp.config("cmake", cmake_config),
	vim.lsp.enable("cmake")
}
