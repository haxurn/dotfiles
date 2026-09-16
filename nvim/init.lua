-- bread's neovim config
-- keymaps are in lua/config/mappings.lua
-- install a patched font & ensure your terminal supports glyphs
-- enjoy :D

-- auto install vim-plug and plugins, if not found
local data_dir = vim.fn.stdpath('data')
if vim.fn.empty(vim.fn.glob(data_dir .. '/site/autoload/plug.vim')) == 1 then
	vim.cmd('silent !curl -fLo ' .. data_dir .. '/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
	vim.o.runtimepath = vim.o.runtimepath
	vim.cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
end

local vim = vim
local Plug = vim.fn['plug#']

-- disable netrw so nvim-tree owns directory opening (e.g. `nvim .`)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.start_time = vim.fn.reltime()
vim.loader.enable() --  SPEEEEEEEEEEED 
vim.call('plug#begin')

Plug('catppuccin/nvim', { ['as'] = 'catppuccin' }) --colorscheme
Plug('ellisonleao/gruvbox.nvim', { ['as'] = 'gruvbox' }) --colorscheme 2
Plug('uZer/pywal16.nvim', { [ 'as' ] = 'pywal16' }) --or, pywal colorscheme
Plug('nvim-lualine/lualine.nvim') --statusline
Plug('nvim-tree/nvim-web-devicons') --pretty icons
Plug('folke/which-key.nvim') --mappings popup
Plug('romgrk/barbar.nvim') --bufferline
Plug('goolord/alpha-nvim') --pretty startup
Plug('nvim-treesitter/nvim-treesitter', { ['branch'] = 'main', ['do'] = ':TSUpdate' }) --improved syntax
Plug('mfussenegger/nvim-lint') --async linter
Plug('nvim-tree/nvim-tree.lua') --file explorer
Plug('windwp/nvim-autopairs') --autopairs 
Plug('lewis6991/gitsigns.nvim') --git
Plug('numToStr/Comment.nvim') --easier comments
Plug('norcalli/nvim-colorizer.lua') --color highlight
Plug('ibhagwan/fzf-lua') --fuzzy finder and grep
Plug('numToStr/FTerm.nvim') --floating terminal
Plug('ron-rs/ron.vim') --ron syntax highlighting
Plug('MeanderingProgrammer/render-markdown.nvim') --render md inline
Plug('emmanueltouzery/decisive.nvim') --view csv files
Plug('folke/twilight.nvim') --surrounding dim

-- glow-up: LSP + completion + diagnostics + UI
Plug('nvim-lua/plenary.nvim') --lua deps (todo-comments)
Plug('mason-org/mason.nvim') --LSP/tool installer
Plug('mason-org/mason-lspconfig.nvim') --mason<->lspconfig bridge
Plug('neovim/nvim-lspconfig') --LSP server configs
Plug('saghen/blink.cmp', { ['tag'] = 'v1.*' }) --fast completion (prebuilt binary)
Plug('rafamadriz/friendly-snippets') --snippet collection
Plug('rachartier/tiny-inline-diagnostic.nvim') --inline error lens
Plug('lukas-reineke/indent-blankline.nvim') --indent guides
Plug('j-hui/fidget.nvim') --LSP progress spinner
Plug('rcarriga/nvim-notify') --pretty notifications
Plug('folke/trouble.nvim') --diagnostics/symbols list
Plug('folke/todo-comments.nvim') --highlight TODO/FIX/HACK
Plug('folke/flash.nvim') --jump anywhere on screen
Plug('kylechui/nvim-surround') --add/change/delete surrounding pairs
Plug('nvim-treesitter/nvim-treesitter-textobjects', { ['branch'] = 'main' }) --syntax-aware text objects
Plug('stevearc/conform.nvim') --formatters
Plug('mbbill/undotree') --undo history tree

vim.call('plug#end')

-- move config and plugin config to alternate files
require("config.theme")
require("config.mappings")
require("config.options")
require("config.autocmd")

require("plugins.alpha")
-- require("plugins.autopairs")
require("plugins.barbar")
require("plugins.colorizer")
require("plugins.colorscheme")
require("plugins.comment")
-- require("plugins.fterm")
-- require("plugins.fzf-lua")
require("plugins.gitsigns")
require("plugins.lualine")
require("plugins.nvim-lint")
require("plugins.nvim-tree") -- early: must hijack directory before VimEnter
require("plugins.render-markdown")
require("plugins.treesitter") -- must load before initial file's FileType fires
-- require("plugins.twilight")
-- require("plugins.which-key")

vim.defer_fn(function() 
		--defer non-essential configs,
		--purely for experimental purposes:
		--this only makes a difference of +-10ms on initial startup
require("plugins.autopairs")
require("plugins.fterm")
require("plugins.fzf-lua")
require("plugins.twilight")
require("plugins.which-key")
-- glow-up configs (order: notify -> blink -> lsp -> rest)
require("plugins.notify")
require("plugins.blink")
require("plugins.lsp")
require("plugins.tiny-diagnostic")
require("plugins.indent")
require("plugins.fidget")
require("plugins.todo")
require("plugins.trouble")
require("plugins.flash")
require("plugins.surround")
require("plugins.textobjects")
require("plugins.conform")
end, 100)

load_theme()
