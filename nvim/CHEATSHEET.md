# nvim cheatsheet

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
`<leader>t` toggle · `<leader>E` reveal current file. Inside: `a` create (`/`=dir), `d` delete, `r` rename, `x`/`c`/`p` cut/copy/paste, `?` help.

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
`<leader>p` cycle theme · `<leader>Fp` pick colorscheme · `<leader>P` plugin manager (`:Lazy`) · `<leader>R` source current file
`<leader>d` duplicate file · `<leader>mv` move file · `<leader>x` chmod +x · `gx` open URL/path under cursor · `<leader>u` undotree

## CSV (decisive)
`<leader>csa` / `<leader>csA` align / clear · `[,` / `],` prev / next column

## Maintenance commands
`:Lazy` plugins (`U` update, `S` sync, `P` profile) · `:Mason` server installer UI · `:checkhealth` diagnose
After `:Lazy update`, commit `nvim/lazy-lock.json` so other machines get the same versions.

---

## Text objects & motions (mini.ai + treesitter-textobjects)
| Key | Action |
|---|---|
| `af` / `if` | around / inside function |
| `ac` / `ic` | around / inside class |
| `aa` / `ia` | around / inside argument |
| `ao` / `io` | around / inside block, loop or conditional |
| `au` / `iu` | around / inside function call |
| `at` / `it` | around / inside html tag |
| `ae` / `ie` | camelCase / snake_case word segment |
| `ag` / `ig` | whole buffer |
| `aq` / `iq`, `ab` / `ib` | any quote, any bracket |
| `]f` / `[f` | next / prev function start |
| `]c` / `[c` | next / prev class start |
| `]a` / `[a` | next / prev argument |
| `[k` | jump up to the sticky context line |

Combine with operators: `dif` delete function body, `yaa` yank argument, `vac` select class.
`an`/`in` + object = next one (e.g. `cinq` change inside next quote).

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
| `<leader>Ft` | TODO comments |
| `<leader>Fy` | registers / yank history |
| `<leader>F?` | help tags |

## Folds
`zc` / `zo` / `za` close / open / toggle (treesitter folds, all open on load) · `zM` / `zR` close / open all.

---

## UI
| Key | Action |
|---|---|
| `<leader>;` | pick a breadcrumb in the top winbar (dropbar) |
| `]]` / `[[` | next / prev reference of word under cursor |
| `<leader>Z` | zen mode |
| `<leader>Nl` / `<leader>Nh` / `<leader>Nd` | last message / message history / dismiss popups |
| `<leader>O` + `s w d h T c D f` | toggle spell, wrap, diagnostics, inlay hints, treesitter, conceal, dim, format-on-save |
| `<leader>?` | keymaps for this buffer only |

The cmdline (`:`) and search pop up in the middle of the screen (noice). Messages appear top right.

## Files: oil + harpoon
| Key | Action |
|---|---|
| `-` | oil: open parent dir as a buffer. Edit lines to rename / move / delete, `:w` applies |
| `<leader>-` | oil in a float |
| `<leader>aa` | harpoon: pin current file |
| `<leader>al` | harpoon menu (reorder / delete by editing) |
| `<leader>1` … `<leader>5` | jump to pinned file N |
| `<leader>an` / `<leader>ap` | next / prev pinned file |
| `<leader>cR` | rename current file (LSP updates imports) |

## Sessions (persistence)
Saved automatically per directory and git branch when you quit.
`<leader>Ss` restore this dir · `<leader>Sl` restore last · `<leader>SS` pick · `<leader>Sd` don't save this one

## Multicursor
| Key | Action |
|---|---|
| `<leader>mn` / `<leader>mN` | add cursor at next / prev match of word (or selection) |
| `<leader>ms` | skip next match |
| `<leader>mA` | cursor on every match |
| `<leader>mj` / `<leader>mk` | add cursor below / above |
| `Ctrl-click` | add / remove cursor |
| `Left` / `Right` | cycle main cursor · `<leader>mx` delete it |
| `Esc` | back to one cursor |

## Yank ring (yanky)
After `p`/`P`: `Ctrl-p` / `Ctrl-n` swap in older / newer yanks. `]p` / `[p` put on line below / above.

## Refactoring
Operators: follow with a motion, or use on a visual selection.
`<leader>rf` extract function · `<leader>rF` … to file · `<leader>rv` extract variable · `<leader>ri` inline variable · `<leader>rI` inline function · `<leader>rs` pick
`<leader>rp` debug-print word/selection · `<leader>rl` print location · `<leader>rc` remove debug prints

## Git: neogit, diffview, conflicts
| Key | Action |
|---|---|
| `<leader>hn` | neogit status (`s` stage, `u` unstage, `c c` commit, `P p` push, `?` help) |
| `<leader>hc` / `<leader>hl` | neogit commit / log |
| `<leader>hv` / `<leader>hV` | diffview open / close (all changes side by side) |
| `<leader>hf` / `<leader>hF` | history of this file / of the repo |
| `<leader>hm` | diff branch vs default branch (review a PR locally) |
| `co` / `ct` / `cb` / `c0` | conflict: take ours / theirs / both / none |
| `]x` / `[x` | next / prev conflict · `<leader>hx` all conflicts to quickfix |

## Debugger (nvim-dap)
Adapters install via mason: python (debugpy), rust/c/c++ (codelldb), go (delve), js/ts.
| Key | Action |
|---|---|
| `F9` / `<leader>Dc` | start / continue |
| `F10` / `F11` / `F12` | step over / into / out |
| `<leader>Db` | toggle breakpoint · `<leader>DB` conditional · `<leader>Dl` log point |
| `<leader>DC` | run to cursor |
| `<leader>De` | evaluate expression (works on selection) |
| `<leader>Du` | toggle debug UI (opens itself when a session starts) |
| `<leader>DR` / `<leader>Dr` / `<leader>Dt` | REPL / restart / terminate |

## Tests (neotest)
pytest, go test, cargo test, vitest, jest.
| Key | Action |
|---|---|
| `<leader>jt` | run nearest test |
| `<leader>jf` / `<leader>jA` / `<leader>jl` | run file / all / last |
| `<leader>jd` | debug nearest test (dap) |
| `<leader>js` | summary tree |
| `<leader>jo` / `<leader>jO` | output / output panel |
| `<leader>jw` | watch file (rerun on save) |
| `]j` / `[j` | next / prev failed test |
