vim.g.barbar_auto_setup = false

require("barbar").setup({
  animation = false,
  tabpages = true,
  focus_on_close = 'left',
  hide = {extensions = false, inactive = false},
  icons = {
    buffer_index = false,
    buffer_number = false,
    button = '',
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = {enabled = true, icon = ' '},
    },
    gitsigns = {
      added = {enabled = true, icon = ' '},
      changed = {enabled = true, icon = ' '},
      deleted = {enabled = true, icon = ' '},
    },
    separator = {left = '▎', right = ''},
    separator_at_end = true,
    modified = {button = '●'},
    pinned = {button = '', filename = true},
    alternate = {filetype = {enabled = false}},
    current = {buffer_index = true},
    inactive = {button = '×'},
    visible = {modified = {buffer_number = false}},
  },
  sidebar_filetypes = {
    NvimTree = true,
  },
})