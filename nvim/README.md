# haxurn's Neovim config

lazy.nvim setup: LSP + completion (blink.cmp), treesitter, formatting (conform), inline
diagnostics, fzf-lua, flash, harpoon, multicursor, sessions, neogit + diffview, a debugger (DAP),
a test runner (neotest), noice popups, breadcrumbs and an animated dashboard. Every icon comes
from one file, `lua/config/icons.lua`. Part of the [dotfiles](https://github.com/haxurn/dotfiles) repo; themes
(catppuccin, tokyonight, kanagawa, rose-pine, gruvbox, pywal16) cycle with `<leader>p`.

Based on [BreadOnPenguins/nvim](https://github.com/BreadOnPenguins/nvim), heavily extended.

## Requirements

- **neovim >= 0.11** (`vim.lsp.config`)
- **tree-sitter CLI** (parsers are compiled from source on the `main` branch)
- **node/npm** for mason-installed servers (ts_ls, pyright, eslint, prettierd)
- a [Nerd Font](https://www.nerdfonts.com/) and a terminal that renders glyphs

`../setup.sh --nvim` installs all of the above and links `~/.config/nvim` here.

## Quickstart

```bash
git clone https://github.com/haxurn/dotfiles.git ~/dotfiles
~/dotfiles/setup.sh --nvim
nvim
```

Standalone (without the rest of the dotfiles):

```bash
git clone https://github.com/haxurn/dotfiles.git ~/dotfiles
ln -sn ~/dotfiles/nvim ~/.config/nvim
nvim   # lazy.nvim bootstraps itself and installs every plugin on first launch
```

- First launch: plugins install, then mason downloads language servers and formatters in the
  background (watch `:Mason`). Restart once for full error-checking.
- Leader is `Space`; press it alone for the which-key popup.
- Full key reference: [`CHEATSHEET.md`](CHEATSHEET.md). Workflows: [`WORKFLOW.md`](WORKFLOW.md).

## Layout

```
nvim/
├── init.lua                 # loads config/* then lazy.nvim
├── lazy-lock.json           # pinned plugin commits (commit it after :Lazy update)
├── install.sh               # used by ../setup.sh
└── lua/
    ├── config/
    │   ├── lazy.lua         # lazy.nvim bootstrap; imports each plugins/<group>
    │   ├── icons.lua        # every glyph used anywhere (diagnostics, git, kinds, dap, ui)
    │   ├── options.lua      # vim.opt values
    │   ├── mappings.lua     # core keymaps (leader = space)
    │   ├── autocmd.lua      # autocommands
    │   └── theme.lua        # theme cycling; choice persists in stdpath("data")/saved_theme
    └── plugins/             # one spec file per plugin (or small related set)
        ├── ui/              # colorschemes, dashboard, statusline, tabs, noice, snacks, which-key, ...
        ├── editor/          # nvim-tree, oil, fzf-lua, flash, harpoon, trouble, sessions, multicursor
        ├── coding/          # completion, treesitter, text objects, formatting, linting, refactoring
        ├── lsp/             # mason + lspconfig, inline diagnostics, lazydev
        ├── git/             # gitsigns, neogit, diffview, git-conflict
        └── tools/           # debugger (dap), tests (neotest), filetype extras
```

To add a plugin: drop a file returning a lazy.nvim spec into the right `plugins/<group>/`
folder and restart. To remove one: delete its file, then `:Lazy clean`. Plugin keys live in the
spec's `keys` table, so the plugin loads on first keypress. `:Lazy` shows load times and updates.

Upgrading from the old vim-plug setup: plugins now live in `~/.local/share/nvim/lazy`. The old
`~/.local/share/nvim/plugged` and `site/autoload/plug.vim` are unused and safe to delete.

## Language servers and tools

Auto-installed by mason (`lua/plugins/lsp/lsp.lua`): lua_ls, pyright, ruff, bashls, rust_analyzer,
gopls, clangd, ts_ls, eslint, html, cssls, jsonls, yamlls, dockerls, jdtls (needs a JDK).
Formatters: stylua, shfmt, prettierd, clang-format. Linters: shellcheck, hadolint.
Debug adapters (mason-nvim-dap): debugpy, codelldb, delve, js-debug-adapter.
