require("twilight").setup({
  dimming = {
    alpha = 0.3,
    color = { "Normal", "#ffffff" },
    term_bg = "#000000",
    inactive = true,
  },
  context = 7,
  treesitter = true,
  expand = {
    "function",
    "method",
    "table",
    "if_statement",
  },
  exclude = {},
})