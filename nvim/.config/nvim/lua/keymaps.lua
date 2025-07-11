vim.g.mapleader = " "
vim.g.maplocalleader = ','

local mode_nv = { "n", "v" }
local mode_v = { "v" }
local mode_i = { "i" }
local nmappings = {
	-- { from = "W", to = ":w<CR>", desc = "保存" },
	{ from = "Q", to = ":q<CR>", desc = "离开" },

	{ from = "<leader>w", to = "<C-w>w", desc = "切换窗口" },
	{ from = "<leader>k", to = "<C-w>k", desc = "切换到上方窗口" },
	{ from = "<leader>j", to = "<C-w>j", desc = "切换到下方窗口" },
	{ from = "<leader>h", to = "<C-w>h", desc = "切换到左侧窗口" },
	{ from = "<leader>l", to = "<C-w>l", desc = "切换到右侧窗口" },
	{ from = "s", to = "<nop>", },
	{ from = "sk", to = ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", desc = "水平分割窗口" },
	{ from = "sj", to = ":set splitbelow<CR>:split<CR>", desc = "水平分割窗口" },
	{ from = "sh", to = ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", desc = "垂直分割窗口" },
	{ from = "sl", to = ":set splitright<CR>:vsplit<CR>", desc = "垂直分割窗口" },
	{ from = "ss", to = "<C-w>o", desc = "关闭其他窗口" },

	{ from = "tk", to = ":tabe<CR>", desc = "新建标签页" },
	{ from = "tj", to = ":tabnew<CR>", desc = "新建标签页" },
	{ from = "th", to = ":tabprevious<CR>", desc = "切换到上一个标签页" },
	{ from = "tl", to = ":tabnext<CR>", desc = "切换到下一个标签页" },
	{ from = "ts", to = ":tabonly<CR>", desc = "关闭其他标签页" },
	{ from = "tx", to = ":tabclose<CR>", desc = "关闭当前标签页" },
	{ from = "tmh", to = ":-tabmove<CR>", desc = "将当前标签页移动到左侧" },
	{ from = "tml", to = ":+tabmove<CR>", desc = "将当前标签页移动到右侧" },

	{ from = "<leader><CR>", to = ":set nohlsearch!<CR>", desc = "切换高亮搜索" },
}

vim.keymap.set("n", "q", "<nop>", { noremap = true })
vim.keymap.set("n", ",q", "q", { noremap = true })

for _, mapping in ipairs(nmappings) do
	vim.keymap.set(mapping.mode or "n", mapping.from, mapping.to, { noremap = true, desc = mapping.desc or "" })
end
