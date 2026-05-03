require("fzf-lua").setup({
    winopts = {
        height = 0.45,
        width = 1,
        row = 0.4,
    },
    defaults = {
        prompt = ">",
        fzf_opts = {
            ["--info"] = "right",
            ["--preview-window"] = "right:50%:wrap",
        },
    },
})