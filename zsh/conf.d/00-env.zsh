# 00-env: OS detection, Homebrew, PATH, core exports
[[ "$OSTYPE" == darwin* ]] && IS_MAC=1 || IS_MAC=0

# Homebrew (Apple Silicon / Intel / Linuxbrew) — before anything that needs brew binaries
if   [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew   ]]; then eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

typeset -U path PATH fpath

# GNU coreutils on macOS so ls/head/date flags match Linux
if (( IS_MAC )) && [[ -n "$HOMEBREW_PREFIX" ]]; then
  [[ -d "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" ]] && path=("$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" $path)
  [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi

# Generic user paths, each guarded (machine-specific ones go in ~/.zshrc.local)
for _p in "$HOME/bin" "$HOME/.local/bin" "$HOME/go/bin" "$HOME/.bun/bin" "$HOME/.cargo/bin" \
          "$HOME/.opencode/bin" "$HOME/.local/share/pnpm" /usr/local/go/bin; do
  [[ -d "$_p" ]] && path=("$_p" $path)
done; unset _p

export EDITOR='nvim' VISUAL='nvim'
export GOPATH="$HOME/go"
export PNPM_HOME="$HOME/.local/share/pnpm"
export BUN_INSTALL="$HOME/.bun"
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"   # lazygit: XDG path on mac too
export BAT_THEME="gruvbox-dark"

# LS_COLORS (zsh never gets this from /etc/profile on Ubuntu); gnubin provides dircolors on mac
[[ -z "$LS_COLORS" ]] && (( $+commands[dircolors] )) && eval "$(dircolors -b)"
