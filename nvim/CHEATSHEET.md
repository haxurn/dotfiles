# nvim cheatsheet (glow-up)

**Leader = `Space`.** Press `Space` and wait → which-key shows everything.
First launch after the upgrade: mason downloads language servers in the background
(watch `:Mason`). Restart once they finish for full error-checking.

---

## LSP — code intelligence (NEW)
Active in any file with a language server (python, rust, go, c/c++, js/ts, lua, bash, html/css, java).

| Key | Action |
|---|---|
| `K` | hover docs |
| `gd` | go to definition (fzf) |
| `gD` | declaration |
| `gr` | references (fzf) |
| `gi` | implementation |
| `gy` | type definition |
| `<leader>rn` | rename symbol (project-wide) |
| `<leader>ca` | code action (quick-fix / import) |
| `<leader>cf` | format buffer (conform: stylua / shfmt / prettierd / ruff / gofmt, LSP fallback) |
| `<leader>cF` | toggle format-on-save (off by default) |
| `<leader>ci` | toggle inlay hints |
| `[d` / `]d` | prev / next diagnostic (jumps + shows msg) |
| `<leader>e` | show full diagnostic for the line |

Errors show **inline next to the line** (error-lens) + a sign in the gutter.

## Autocomplete (NEW — blink.cmp)
| Key | Action |
|---|---|
| `Tab` | accept / next item |
| `Shift-Tab` | previous item |
| `Ctrl-Space` | open menu manually |
| `Ctrl-e` | dismiss |
| `Tab` (in snippet) | jump to next placeholder |

Ghost text previews the top suggestion as you type.

## Trouble — error/symbol lists (NEW)
| Key | Action |
|---|---|
| `<leader>T` | toggle diagnostics list (headline) |
| `<leader>Xx` | all diagnostics |
| `<leader>Xb` | buffer diagnostics |
| `<leader>Xs` | symbols outline |
| `<leader>Xt` | TODO/FIX/HACK list |
| `<leader>Xq` / `<leader>Xl` | quickfix / location list |

## Git hunks (NEW — gitsigns)
| Key | Action |
|---|---|
| `]h` / `[h` | next / prev changed hunk |
| `<leader>hs` / `<leader>hr` | stage / reset hunk (works on visual selection too) |
| `<leader>hS` / `<leader>hR` | stage / reset whole buffer |
| `<leader>hp` | preview hunk diff |
| `<leader>hb` | blame current line |
| `<leader>hB` | toggle inline blame for every line |
| `<leader>hd` | diff this file |

---

## Find / grep (fzf-lua)
| Key | Action |
|---|---|
| `<leader>f` | find files (cwd) |
| `<leader>g` | live grep contents |
| `<leader>G` | grep word under cursor |
| `<leader>Fr` | resume last search |
| `<leader>Fh` / `<leader>Fc` / `<leader>Fl` / `<leader>Ff` | files in `~` / `~/.config` / `~/.local/src` / parent |

Inside fzf: `Ctrl-f/b` page, `F4` toggle preview, `Shift-up/down` scroll preview, `Alt-a` select all.

## Buffers (barbar — top bar)
| Key | Action |
|---|---|
| `Shift-l` / `Shift-h` | next / prev buffer |
| `Alt-1`…`Alt-9` / `Alt-0` | jump to buffer N / last |
| `Alt-Shift-l` / `Alt-Shift-h` | move buffer right / left |
| `Alt-p` | pin |
| `<leader>q` / `<leader>Q` / `<leader>U` | close / force close / close all |
| `<leader>vs` | vsplit + next buffer |

## Windows
`Ctrl-h/j/k/l` move · `F5/F6` height ± · `F7/F8` width ±

## File tree (nvim-tree)
`<leader>t` toggle. Inside: `a` create (`/`=dir), `d` delete, `r` rename, `x`/`c`/`p` cut/copy/paste, `?` help.

## Terminal
`<leader>z` float term · `Alt-z` toggle it (works from inside too) · `<leader>hg` lazygit · `<leader>H` btop · `Ctrl-\ Ctrl-\` terminal → normal mode (Esc is left for TUIs)

## Comments
`gcc` line · `gc`+motion (e.g. `gcap`) · `gc` (visual) · `gco`/`gcO` below/above · `gb`+motion block

## Jump & surround (NEW)
| Key | Action |
|---|---|
| `s` + chars | flash: jump anywhere on screen via label (replaces builtin `s`; use `cl`) |
| `S` | flash: select expanding treesitter node (function/block/arg) |
| `ysiw"` | surround word with `"` |
| `yss)` | surround whole line with `()` |
| `cs"'` | change surrounding `"` → `'` |
| `ds(` | delete surrounding parens |
| visual + `S` | surround the selection |

## Editing / QoL (NEW additions marked *)
| Key | Action |
|---|---|
| `<leader>w` | save |
| `<leader>s` | search-replace all |
| `Alt-j` / `Alt-k` * | move line/selection down / up |
| `n` / `N` * | next/prev match, centered |
| `Ctrl-d` / `Ctrl-u` * | half-page scroll, centered |
| `<` / `>` (visual) * | indent, keep selection |
| `<leader>i` (visual) | auto-indent, keep selection |
| `Esc` * | clear search highlight |
| `<leader>W` | toggle wrap · `<leader>nn` toggle rel numbers · `<leader>l` twilight dim |

## Theme / files / misc
`<leader>p` cycle theme · `<leader>P` PlugInstall · `<leader>R` reload config
`<leader>d` duplicate file · `<leader>mv` move file · `<leader>x` chmod +x · `gx` open URL/path under cursor · `<leader>u` undotree

## CSV (decisive)
`<leader>csa` / `<leader>csA` align / clear · `[,` / `],` prev / next column

## Maintenance commands
`:Mason` server installer UI · `:checkhealth` diagnose · `:PlugUpdate` update plugins
`:Trouble` lists · `:Lazy`?(no — vim-plug: `:PlugStatus`)

---

## Text objects & motions (treesitter-textobjects)
| Key | Action |
|---|---|
| `af` / `if` | around / inside function |
| `ac` / `ic` | around / inside class |
| `aa` / `ia` | around / inside argument |
| `]f` / `[f` | next / prev function start |
| `]c` / `[c` | next / prev class start |

Combine with operators: `dif` delete function body, `yaa` yank argument, `vac` select class.

## fzf extras
| Key | Action |
|---|---|
| `<leader>b` | buffers |
| `<leader>o` | recent files (cwd) |
| `<leader>Fg` | git status (changed files) |
| `<leader>Fs` | document symbols |
| `<leader>Fk` | keymaps |
| `<leader>Fd` | diagnostics |
| `<leader>Fr` | resume last picker |

## Folds
`zc` / `zo` / `za` close / open / toggle (treesitter folds, all open on load) · `zM` / `zR` close / open all.
