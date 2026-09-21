# dotfiles

Cross-platform (macOS + Linux) dotfiles for zsh, tmux, neovim, git, kitty / ghostty / alacritty,
lazygit, btop, bat and VS Code. Terminals use **Alacritty's default palette** (kitty and ghostty
replicate it); tmux, fzf and the TUIs use **Gruvbox Dark** to match the nvim colorscheme. VS Code
keeps its own.

Each terminal ships three palettes under `terminals/<term>/themes/` — `alacritty-default` (active),
`gruvbox-dark` and `catppuccin-frappe`. Switch by changing one line:

| Terminal | File | Line |
|---|---|---|
| kitty | `terminals/kitty/kitty.conf` | `include themes/<name>.conf` |
| ghostty | `terminals/ghostty/config` | `theme = <name>` |
| alacritty | `terminals/alacritty/alacritty.toml` | `import = [".../themes/<name>.toml"]` |

nvim cycles its own colorscheme separately (gruvbox / catppuccin / pywal16); the choice persists in
`$XDG_DATA_HOME/nvim/saved_theme`, outside the repo.

## Quick setup

```bash
git clone https://github.com/haxurn/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh            # interactive menu
./setup.sh --all -y   # everything, no prompts
```

On a fresh Mac `setup.sh` offers to install Xcode Command Line Tools and Homebrew first, then runs
`brew bundle` on `packages/Brewfile`. On Ubuntu/Debian it uses apt (`packages/apt.txt`) and falls
back to GitHub releases for what apt lacks or ships too old (neovim, lazygit, delta, tree-sitter,
Nerd Font). Arch (`pacman.txt`) and Fedora (`dnf.txt`) are best-effort.

Existing files are never deleted: they move to `~/.dotfiles_backup/<timestamp>/` keeping their
path relative to `$HOME`.

## Options

```
./setup.sh [components] [options]

Components:  --all  --zsh  --tmux  --nvim  --git  --terminals  --tools  --vscode
             --devtools        compilers + fullstack toolchain; NOT part of --all
Options:     --packages-only   install packages, link nothing
             --no-packages     link/configure only
             --dry-run         print every action, change nothing
             -y, --yes         assume yes (implied when stdin is not a tty)
```

Each `<component>/install.sh` also runs standalone (`--devtools` and `--vscode` are
manifest/function-only and have no directory).

## Dev toolchain (`--devtools`)

Opt-in, and deliberately excluded from `--all` so a minimal server or container
install never drags in a JDK. Packages live in `packages/Brewfile.devtools` and
`packages/{apt,pacman,dnf}-devtools.txt`.

```bash
./setup.sh --devtools        # toolchain only
./setup.sh --all --devtools  # everything
```

Covers TypeScript/Node, Python, Go and Java/Kotlin: `mise`, `uv`, `python@3.13`,
`pnpm`, `openjdk@21`, `kotlin`, `cmake`, plus linters (`golangci-lint`, `ktlint`,
`hadolint`), container tools (`lazydocker`, `dive`, `k9s`, `kubectl`) and daily
drivers (`jq`, `yq`, `httpie`, `just`, `watchexec`, `difftastic`, ...).

**Databases run in Docker; only the clients are installed** -- `psql` (libpq),
`redis-cli`, `mongosh`. No always-on local daemons.

**Node versions**: `mise` takes over when installed and `70-tools.zsh` then skips
the `fnm` block, so only one tool hooks the node shim.

**Java**: `openjdk@21` is keg-only. `00-env.zsh` exports `JAVA_HOME`, which covers
the shell and nvim/jdtls. GUI apps and `/usr/libexec/java_home` (Android Studio,
Gradle) additionally need the JDK registered system-wide -- one sudo step setup.sh
deliberately does not run for you:

```bash
sudo ln -sfn /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk \
             /Library/Java/JavaVirtualMachines/openjdk-21.jdk
```

## Layout

```
dotfiles/
├── setup.sh                 # dispatcher: flags, menu, mac bootstrap, packages, components
├── lib/                     # shared bash (bash 3.2 safe): log, os detect, link, pkg, fallbacks
├── packages/                # Brewfile, apt.txt, pacman.txt, dnf.txt (+ *-terminals, *-devtools)
├── scripts/check.sh         # shellcheck + syntax + parse + dry-run
├── scripts/docker-smoke.sh  # end-to-end on ubuntu:24.04
├── zsh/
│   ├── .zshrc               # ~25 lines; sources conf.d/ + ~/.zshrc.local
│   ├── conf.d/NN-*.zsh      # env, tmux, omz, options, completion, keybinds, aliases, tools, integrations, plugins
│   ├── functions/           # autoloaded: mkcd fkill gcof ports msfs y
│   └── zshrc.local.example  # copied to ~/.zshrc.local once; machine-specific stuff lives there
├── tmux/                    # tmux.conf + scripts/sessionizer.sh
├── nvim/                    # vim-plug config: LSP, blink.cmp, treesitter, conform, fzf-lua, ...
├── git/                     # gitconfig (delta, aliases), ignore; identity in ~/.gitconfig.local
├── terminals/               # kitty, ghostty, alacritty (same font + palette)
├── tools/                   # lazygit, btop, bat
└── vscode/settings.json
```

## Machine-specific config

| File | Purpose |
|---|---|
| `~/.zshrc.local` | extra PATH, SDKs, secrets, tool hooks. Set `DOTFILES_NO_TMUX=1` to stop tmux auto-attach. |
| `~/.gitconfig.local` | `user.name`, `user.email`, signing key. Seeded from your old `~/.gitconfig` on first run. |

Both are untracked (`*.local` in `.gitignore`).

## After install

- **zsh**: `exec zsh`. tmux auto-attaches session `main` (not under ssh / VS Code / Warp / Kiro).
- **tmux**: plugins install headless; `prefix + I` (Ctrl-a I) if any are missing.
- **nvim**: first launch installs plugins, then mason downloads language servers + formatters (`:Mason`).
  Needs `tree-sitter` CLI (installed by setup) and a Nerd Font (installed by `--terminals`).
- **git**: `git config user.email` must come from `~/.gitconfig.local`.
- **VS Code**: `--vscode` copies `settings.json` only when none exists (never overwrites, never links:
  VS Code writes extension state into it). Theme is left to you. Same file works for Cursor / Kiro.

## Keybinds

### zsh
| Key | Action |
|---|---|
| `Ctrl-r` / `Ctrl-t` / `Alt-c` | fzf history / files / cd (tmux popup) |
| `Ctrl-g Ctrl-{f,b,t,r,h,s}` | fzf-git: files / branches / tags / remotes / hashes / stashes |
| `Tab` | fzf-tab completion with previews |
| `Up` / `Down` | history substring search |
| `Alt-←` / `Alt-→` | word navigation |
| `mkcd` `fkill` `gcof` `ports` `ts` `y` | functions: mkdir+cd, fzf kill, fzf branch, listening ports, tmux sessionizer, yazi |

### tmux (prefix `Ctrl-a`)
| Key | Action |
|---|---|
| `\` / `-` | split horizontal / vertical (current path) |
| `h/j/k/l` · `H/J/K/L` | navigate · resize panes |
| `m` | zoom pane |
| `Alt-\`` | toggle floating scratch session |
| `g` / `b` | lazygit / btop popup |
| `f` / `s` | sessionizer (projects) / session picker |
| `Shift-←/→` · `Tab` | prev/next window · last window |
| `v` `y` (copy mode) | select / yank to system clipboard (tmux-yank) |
| `r` | reload config |

### neovim (leader `Space`)
Full reference in [`nvim/CHEATSHEET.md`](nvim/CHEATSHEET.md), workflows in [`nvim/WORKFLOW.md`](nvim/WORKFLOW.md).

| Key | Action |
|---|---|
| `<leader>f` / `g` / `b` / `o` | files / grep / buffers / recent |
| `<leader>t` · `s` + chars | file tree · flash jump |
| `K` · `gd` · `gr` · `<leader>ca` · `<leader>rn` | hover · definition · references · code action · rename |
| `<leader>cf` / `cF` / `ci` | format · toggle format-on-save · toggle inlay hints |
| `<leader>hg` · `<leader>H` · `Alt-z` | lazygit · btop · toggle terminal |
| `<leader>u` | undotree |
| `af` `if` `ac` `ic` `aa` `ia` · `]f` `[f` | treesitter text objects · next/prev function |
| `Tab` | accept completion |

## Verify

```bash
scripts/check.sh          # shellcheck, bash/zsh syntax, tmux parse, lua load, dry-run
scripts/docker-smoke.sh   # full install on ubuntu:24.04, run twice for idempotency
```

macOS checklist (no CI for it yet): fresh user → `./setup.sh --all` → accept CLT + Homebrew →
`exec zsh` (no p10k warnings, `ls` is eza, `ports` uses lsof, `open .` works) → tmux
`display -p '#{default-shell}'` shows zsh, copy-mode `y` then Cmd-V pastes → nvim `:checkhealth`
clipboard = pbcopy, `Alt-j` moves a line (option-as-alt) → rerun setup: everything reports "linked".

## Uninstall

```bash
ls ~/.dotfiles_backup/        # pick the timestamp
rm ~/.zshrc ~/.p10k.zsh ~/.gitconfig ~/.config/{nvim,tmux/tmux.conf,kitty,ghostty,alacritty,lazygit}
cp -r ~/.dotfiles_backup/<ts>/. ~/   # restore
```

## Contributing rules

- Shell: bash 3.2 syntax only (macOS `/bin/bash`). No `declare -A`, `mapfile`, `${var,,}`, `readlink -f`, `sed -i`, `head -n -1`.
- Every mutating command goes through `run` so `--dry-run` stays honest.
- Every `ensure_*` fallback is a no-op when the tool already exists.
- `scripts/check.sh` must pass before committing.
