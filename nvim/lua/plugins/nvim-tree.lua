require("nvim-tree").setup({
    hijack_netrw = true,
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = true,
    },
    view = {
        adaptive_size = true,
    },
    renderer = {
        group_empty = true,
        indent_width = 2,
    },
})