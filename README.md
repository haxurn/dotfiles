# dotfiles

My dotfiles for tmux, zsh, neovim, and VSCode.

## Quick Setup

```bash
git clone https://github.com/haxurn/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

Then select what you want to install (1-7).

## Options

```bash
./setup.sh --all     # Install everything
./setup.sh --tmux    # Tmux only
./setup.sh --zsh     # Zsh only
./setup.sh --nvim    # Neovim only
```

## After Install

### Tmux
- Press `Ctrl+a` then `I` to install plugins

### Zsh
- Restart terminal or `source ~/.zshrc`
- Run `p10k configure` to customize prompt

### Neovim
- Run `nvim` and `:PlugInstall`

### VSCode
- Copy `settings.json` to your VSCode settings folder:
  - Linux: `~/.config/Code/User/settings.json`
  - macOS: `~/Library/Application Support/Code/User/settings.json`
  - Windows: `%APPDATA%\Code\User\settings.json`
- Or use the **Settings Sync** extension and link this file

## Keybinds

### Tmux
| Key | Action |
|-----|--------|
| `Ctrl+a` | Prefix |
| `\` | Split horizontal |
| `-` | Split vertical |
| `h/j/k/l` | Navigate panes |
| `r` | Reload config |

### Neovim
| Key | Action |
|-----|--------|
| `Space+f` | Find files |
| `Space+g` | Grep |
| `Space+t` | File tree |
| `Ctrl+h/j/k/l` | Navigate windows |

## Uninstall

```bash
rm ~/.config/tmux/tmux.conf
rm ~/.zshrc
rm ~/.config/nvim
rm ~/.config/Code/User/settings.json
# Restore backup if needed from ~/.dotfiles_backup/
```

## Folder Structure

```
dotfiles/
├── nvim/           # Neovim config (lua)
├── tmux/            # Tmux config
├── zsh/             # Zsh config & plugins
├── vscode/          # VSCode/VSCodium settings (cross-platform)
│   └── settings.json
├── setup.sh         # Installer script
└── README.md
```
