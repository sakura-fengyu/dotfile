-- 开启 vim 的真彩色 true color
vim.o.termguicolors = true
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1

-- ================== 基础设置 ======================

-- 启用快速终端模式，减少刷新延迟
vim.o.ttyfast = true
-- 切换文件时自动更新当前工作目录
vim.o.autochdir = true
-- 允许在当前目录的 .exrc 文件加载本地配置 配合secure选项保障安全性，避免执行潜在恶意代码
vim.o.exrc = true
-- 禁用对 exrc 配置文件中某些危险命令的限制（如 :!）
vim.o.secure = false
--  将 Vim 的默认寄存器（""）与系统剪贴板（"+）绑定 vim.api.nvim_set_option("clipboard","unnamedplus")
vim.o.clipboard = 'unnamedplus'


-- ================== 显示与导航 ======================
-- 显示行号 绝对行号，用于定位代码位置（与 relativenumber 区分）
vim.o.number = true
-- 显示相对行号（当前行偏移值） 与 number 同用，便于快速跳转
vim.o.relativenumber = true
-- 高亮当前行 提升代码可视化，需配合配色方案生效
vim.o.cursorline = true
-- 输入Tab时插入实际制表符 与tabstop 配合控制缩进显示，影响代码格式一致性
vim.o.expandtab = false
-- 设置显示制表符宽度为 4 个空格
vim.o.tabstop = 4
-- 在缩进时智能处理 Tab（如首行缩进用空格，后续用 Tab）
vim.o.smarttab = true
-- 自动缩进时每次移动 4 个空格
vim.o.shiftwidth = 4
-- 将 Tab 显示为 4 个空格（仅影响输入/退格行为）
vim.o.softtabstop = 4
-- 自动复制上一行缩进
vim.o.autoindent = true
-- 显示不可见字符 需配合 listchars 定义具体显示样式
vim.o.list = true
-- 定义不可见字符的显示方式
vim.o.listchars = 'tab:|\\ ,trail:▫'
-- 光标距离窗口边缘至少保留 8 行
vim.o.scrolloff = 8

vim.o.jumpoptions = "stack"


-- ================== 输入与效率 ======================
-- 禁止映射组合键的超时等待（如 <leader> 延迟）
vim.o.ttimeoutlen = 0
-- 禁用映射超时机制
vim.o.timeout = false
-- 定义 :view 保存视图时保留的信息（光标位置、折叠状态等）
vim.o.viewoptions = 'cursor,folds,slash,unix'
-- 启用文本自动换行
vim.o.wrap = true
-- 禁用自动换行（0 表示不限制宽度）与wrap区分：wrap 控制显示换行，textwidth 控制输入换行
vim.o.textwidth = 0
-- 禁用自定义缩进表达式（使用默认缩进逻辑）
vim.o.indentexpr = ''
-- 根据缩进层级自动折叠代码块
vim.o.foldmethod = 'indent'
-- 默认展开所有折叠
vim.o.foldlevel = 99
-- 启用折叠功能
vim.o.foldenable = true
-- 文件打开时默认展开所有折叠 与foldlevel区分：前者是初始状态，后者是手动设置
vim.o.foldlevelstart = 99
-- 新建窗口默认在右侧打开
vim.o.splitright = true
-- 新建窗口默认在下方打开
vim.o.splitbelow = true
-- 隐藏底部状态栏的模式提示
-- vim.o.showmode = true
-- 搜索时忽略大小写 可被 smartcase 覆盖
vim.o.ignorecase = true
-- 如果搜索词含大写字母，则区分大小写 ignorecase 和 smartcase 共同控制搜索灵敏度
vim.o.smartcase = true
-- 禁用命令完成时的冗余提示 shortmess 控制信息提示的简洁性
vim.o.shortmess = vim.o.shortmess .. 'c'

-- ================== 高级功能 ======================
-- 实时显示 :substitute 替换效果（使用分割窗口）
vim.o.inccommand = 'split'
-- 定义自动补全行为 longest：自动选择最长匹配项   menuone：仅一个匹配时仍显示菜单   noselect：不自动选中首个补全项   preview：显示补全项的预览窗口
vim.o.completeopt = 'longest,noinsert,menuone,noselect,preview'
-- 最终值为 menuone,noinsert,noselect,preview（后一次设置覆盖前一次）
vim.o.completeopt = 'menuone,noinsert,noselect,preview'
-- 执行宏或批量操作时延迟刷新界面
-- vim.o.lazyredraw = true
-- 用视觉提示（如闪烁）代替响铃
vim.o.visualbell = true
-- 高亮第 100 列作为代码长度参考线
-- vim.o.colorcolumn = '100'
-- 设置自动保存和插件触发的间隔为 100 毫秒
vim.o.updatetime = 100
-- 允许在空白区域设置光标（如多行注释末尾）
vim.o.virtualedit = ''

vim.o.winborder = 'bold'

vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('cache') .. '/undo' -- 设置持久化撤销文件目录

-- 当打开或新建md文件时 启用拼写检查
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { pattern = "*.md", command = "setlocal spell", })

-- 自动将工作目录切换到当前文件所在目录，方便执行文件相关命令
-- %:p:h：Neovim 特殊变量  %：当前文件名   :p：取完整路径（如 /home/user/file.txt）   :h：取路径的目录部分（即 :p:h = /home/user）
vim.api.nvim_create_autocmd("BufEnter", { pattern = "*", command = "silent! lcd %:p:h", })

-- vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])

-- 当通过 :term 命令在 Vim 中打开终端（Terminal Buffer）时，自动进入插入模式（Insert Mode），无需手动按 i 键切换
vim.cmd([[autocmd TermOpen term://* startinsert]])

-- -=r: 移除“在插入模式下按回车键时，自动为新行添加注释前缀”的功能。
-- -=o: 移除“使用 o 或 O 命令创建新行时，自动添加当前行的注释前缀”的功能。
-- -=c: 移除“C 风格注释在回车时自动添加星号和空格”的功能。
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
	desc = "Disable New Line Comment"
})
