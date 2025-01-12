-- Interface settings
vim.cmd.colorscheme("kanagawa-wave")
vim.opt.termguicolors = true
vim.opt.title = false
vim.opt.titlestring = "It\"s hacking time"
vim.opt.syntax = "enable"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = true              -- Enable line wrapping
vim.opt.linebreak = true         -- Wrap at word boundaries
vim.opt.showbreak = "↪"          -- Show a symbol at the start of wrapped lines
vim.opt.wildmenu = true          -- Enable enhanced command-line completion
vim.opt.wildmode = "longest:full" -- Completion mode for commands
vim.opt.list = true              -- Show whitespace characters
-- vim.opt.listchars = { tab = "  ", trail = " ", space = " " } -- Custom symbols for whitespace

-- Search
vim.opt.hlsearch = true          -- Highlight all matches of search
vim.opt.incsearch = true         -- Incremental search (search while typing)
vim.opt.ignorecase = true        -- Ignore case when searching
vim.opt.smartcase = true         -- Override ignorecase if search includes uppercase

-- Indentation settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftround = true

-- File system settings
vim.opt.autoread = true        -- Automatically read file when changed outside of the file
vim.opt.clipboard = "unnamedplus" -- Use the system clipboard

-- Nvimtree
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
