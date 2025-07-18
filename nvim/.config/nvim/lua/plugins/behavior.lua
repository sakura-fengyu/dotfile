return {
	-- colorscheme 主题
	-- {
	-- 	"Mofiqul/dracula.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd("colorscheme dracula")
	-- 	end,
	-- },
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {},
	-- 	config = function()
	-- 		vim.cmd("colorscheme tokyonight-night")
	-- 	end,
	-- },

	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme catppuccin")
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { light = "latte", dark = "mocha" },
				transparent_background = false,
				term_colors = true,
				styles = {
					comments = { "italic" },
					functions = { "italic" },
					keywords = { "italic" },
					strings = { "italic" },
					variables = {},
				},
			})
		end
	},

	-- statusline 底部状态栏
	{

		"nvim-lualine/lualine.nvim",
		-- You can optionally lazy-load heirline on UiEnter
		-- to make sure all required plugins and colorschemes are loaded before setup
		event = "UiEnter",
		config = function()
			require('lualine').setup {
				options = {
					icons_enabled = true,
					theme = 'auto',
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = true,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					}
				},
				sections = {
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff', 'diagnostics' },
					lualine_c = { 'filename' },
					lualine_x = { 'progress' },
					lualine_y = { 'filesize', 'fileformat', 'filetype' },
					lualine_z = { 'location' }
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { 'filename' },
					lualine_x = { 'location' },
					lualine_y = {},
					lualine_z = {}
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {}
			}
		end
	},

	-- tabline
	{
		'akinsho/bufferline.nvim',
		dependencies = 'nvim-tree/nvim-web-devicons',
		opts = {
			options = {
				mode = "tabs",
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level, _, _)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,
				indicator = {
					icon = '▎', -- this should be omitted if indicator style is not 'icon'
					-- style = 'icon' | 'underline' | 'none',
					style = "icon",
				},
				show_buffer_close_icons = false,
				show_close_icon = false,
				enforce_regular_tabs = true,
				show_duplicate_prefix = false,
				tab_size = 16,
				padding = 0,
				separator_style = "thick",
			}
		}
	},

	-- winbar 类似IDE提供winbar
	{
		"Bekaboo/dropbar.nvim",
		config = function()
			local api = require("dropbar.api")
			vim.keymap.set('n', '<Leader>;', api.pick)
			vim.keymap.set('n', '[c', api.goto_context_start)
			vim.keymap.set('n', ']c', api.select_next_context)

			local confirm = function()
				local menu = api.get_current_dropbar_menu()
				if not menu then
					return
				end
				local cursor = vim.api.nvim_win_get_cursor(menu.win)
				local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
				if component then
					menu:click_on(component)
				end
			end

			local quit_curr = function()
				local menu = api.get_current_dropbar_menu()
				if menu then
					menu:close()
				end
			end

			require("dropbar").setup({
				menu = {
					-- When on, automatically set the cursor to the closest previous/next
					-- clickable component in the direction of cursor movement on CursorMoved
					quick_navigation = true,
					---@type table<string, string|function|table<string, string|function>>
					keymaps = {
						['<LeftMouse>'] = function()
							local menu = api.get_current_dropbar_menu()
							if not menu then
								return
							end
							local mouse = vim.fn.getmousepos()
							if mouse.winid ~= menu.win then
								local parent_menu = api.get_dropbar_menu(mouse.winid)
								if parent_menu and parent_menu.sub_menu then
									parent_menu.sub_menu:close()
								end
								if vim.api.nvim_win_is_valid(mouse.winid) then
									vim.api.nvim_set_current_win(mouse.winid)
								end
								return
							end
							menu:click_at({ mouse.line, mouse.column }, nil, 1, 'l')
						end,
						['<CR>'] = confirm,
						['i'] = confirm,
						['<esc>'] = quit_curr,
						['q'] = quit_curr,
						['n'] = quit_curr,
						['<MouseMove>'] = function()
							local menu = api.get_current_dropbar_menu()
							if not menu then
								return
							end
							local mouse = vim.fn.getmousepos()
							if mouse.winid ~= menu.win then
								return
							end
							menu:update_hover_hl({ mouse.line, mouse.column - 1 })
						end,
					},
				},
			})
		end

	},

	-- scrollbar gissigns hignlightSearch 滚动高亮
	{
		"petertriho/nvim-scrollbar",
		dependencies = {
			"kevinhwang91/nvim-hlslens",
			"lewis6991/gitsigns.nvim",
		},
		config = function()
			local group = vim.api.nvim_create_augroup("scrollbar_set_git_colors", {})
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*",
				callback = function()
					vim.cmd([[
						hi! ScrollbarGitAdd guifg=#8CC85F
						hi! ScrollbarGitAddHandle guifg=#A0CF5D
						hi! ScrollbarGitChange guifg=#E6B450
						hi! ScrollbarGitChangeHandle guifg=#F0C454
						hi! ScrollbarGitDelete guifg=#F87070
						hi! ScrollbarGitDeleteHandle guifg=#FF7B7B ]])
				end,
				group = group,
			})
			require("scrollbar.handlers.search").setup({})
			require('gitsigns').setup()
			require("scrollbar.handlers.gitsigns").setup()
			require("scrollbar").setup({
				show = true,
				handle = {
					text = " ",
					color = "#928374",
					hide_if_all_visible = true,
				},
				marks = {
					Search = { color = "yellow" },
					Misc = { color = "purple" },
				},
				handlers = {
					cursor = false,
					diagnostic = true,
					gitsigns = true,
					handle = true,
					search = true,
				},
			})
		end,

	},
}
