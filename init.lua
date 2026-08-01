vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .."/lazy/lazy.nvim"

vim.opt.rtp:prepend(lazypath)

require("config.keymaps")
require("lazy").setup("plugins")

vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true

-- ignore checkhealth nvim warning
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0

-- highlight tambahan biar tree-sitter groups punya warna
local hl = vim.api.nvim_set_hl

hl(0, "PreProc", { fg = "#e5c07b" })       -- #include, #define, #ifndef dkk
hl(0, "Keyword", { fg = "#c678dd", bold = true }) -- return, if, for, while dkk
hl(0, "Type", { fg = "#56b6c2" })          -- int, char, void, float dkk
hl(0, "Include", { link = "PreProc" })
hl(0, "@keyword.import", { link = "Include" })
hl(0, "@keyword.directive", { link = "PreProc" })
hl(0, "@keyword.directive.define", { link = "PreProc" })
hl(0, "@keyword.return", { link = "@keyword" })
hl(0, "@type.builtin", { fg = "#56b6c2" })
hl(0, "Number", { fg = "#d19a66" })        -- angka: 0, 42, 100 dkk
hl(0, "Constant", { fg = "#d19a66" })      -- #define CONSTANTA, MAX_COUNT dkk
hl(0, "@constant.macro", { fg = "#d19a66" })
