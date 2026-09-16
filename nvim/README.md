# haxurn's Neovim config

Lightweight vim-plug setup: LSP + completion (blink.cmp), treesitter, formatting (conform),
inline diagnostics, fzf-lua, flash, surround, git hunks, lazygit/btop floats, undotree and an
animated dashboard. Part of the [dotfiles](https://github.com/haxurn/dotfiles) repo; the
colorscheme is gruvbox (transparent), switchable with `<leader>p`.

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
nvim   # vim-plug bootstraps and :PlugInstall runs on first launch
```

- First launch: plugins install, then mason downloads language servers and formatters in the
  background (watch `:Mason`). Restart once for full error-checking.
- Leader is `Space`; press it alone for the which-key popup.
- Full key reference: [`CHEATSHEET.md`](CHEATSHEET.md). Workflows: [`WORKFLOW.md`](WORKFLOW.md).

## Layout

```
nvim/
├── init.lua                 # vim-plug bootstrap, Plug() list, require() order (deferred block for speed)
├── install.sh               # used by ../setup.sh
└── lua/
    ├── config/
    │   ├── options.lua      # vim.opt values
    │   ├── mappings.lua     # keymaps (leader = space)
    │   ├── autocmd.lua      # autocommands
    │   └── theme.lua        # theme cycling; choice persists in stdpath("data")/saved_theme
    └── plugins/             # one file per plugin
```

To add or remove a plugin: edit the `Plug()` list in `init.lua`, add/remove the matching
`require("plugins.<name>")`, then `:PlugInstall` / `:PlugClean`.

## Language servers and tools

Auto-installed by mason (`lua/plugins/lsp.lua`): lua_ls, pyright, ruff, bashls, rust_analyzer,
gopls, clangd, ts_ls, eslint, html, cssls, jsonls, yamlls, dockerls, jdtls (needs a JDK).
Formatters: stylua, shfmt, prettierd, clang-format. Linters: shellcheck, hadolint.
