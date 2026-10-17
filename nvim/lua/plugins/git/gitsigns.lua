-- git signs in the gutter + hunk actions (<leader>h*)
return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require('gitsigns').setup {
		  on_attach = function(bufnr)
		    local gs = require('gitsigns')
		    local function m(mode, k, fn, desc)
		      vim.keymap.set(mode, k, fn, { buffer = bufnr, silent = true, desc = desc })
		    end
		    -- hunk navigation
		    m('n', ']h', function() gs.nav_hunk('next') end, 'next git hunk')
		    m('n', '[h', function() gs.nav_hunk('prev') end, 'prev git hunk')
		    -- stage / reset / preview
		    m('n', '<leader>hs', gs.stage_hunk, 'stage hunk')
		    m('n', '<leader>hr', gs.reset_hunk, 'reset hunk')
		    m('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'stage selection')
		    m('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'reset selection')
		    m('n', '<leader>hS', gs.stage_buffer, 'stage buffer')
		    m('n', '<leader>hR', gs.reset_buffer, 'reset buffer')
		    m('n', '<leader>hp', gs.preview_hunk, 'preview hunk')
		    m('n', '<leader>hd', gs.diffthis, 'diff this')
		    m('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'blame line')
		    m('n', '<leader>hB', gs.toggle_current_line_blame, 'toggle inline blame')
		  end,
		  signs = {
		    add          = { text = '┃' },
		    change       = { text = '┃' },
		    delete       = { text = '_' },
		    topdelete    = { text = '‾' },
		    changedelete = { text = '~' },
		    untracked    = { text = '┆' },
		  },
		  signs_staged = {
		    add          = { text = '┃' },
		    change       = { text = '┃' },
		    delete       = { text = '_' },
		    topdelete    = { text = '‾' },
		    changedelete = { text = '~' },
		    untracked    = { text = '┆' },
		  },
		  signs_staged_enable = true,
		  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
		  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
		  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
		  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
		  watch_gitdir = {
		    follow_files = true
		  },
		  auto_attach = true,
		  attach_to_untracked = false,
		  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
		  current_line_blame_opts = {
		    virt_text = true,
		    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
		    delay = 1000,
		    ignore_whitespace = false,
		    virt_text_priority = 100,
		    use_focus = true,
		  },
		  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
		  sign_priority = 6,
		  update_debounce = 100,
		  status_formatter = nil, -- Use default
		  max_file_length = 40000, -- Disable if file is longer than this (in lines)
		  preview_config = {
		    -- Options passed to nvim_open_win
		    border = 'single',
		    style = 'minimal',
		    relative = 'cursor',
		    row = 0,
		    col = 1
		  },
		}
	end,
}
