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
  # keg-only kegs brew does not symlink into the prefix (--devtools)
  # JDK: prefer the LTS Android/Gradle support, else whatever keg is present
  # (e.g. the openjdk that `kotlin` pulls in as a dependency).
  for _jdk in openjdk@21 openjdk@17 openjdk; do
    if [[ -d "$HOMEBREW_PREFIX/opt/$_jdk/bin" ]]; then
      path=("$HOMEBREW_PREFIX/opt/$_jdk/bin" $path)
      export JAVA_HOME="$HOMEBREW_PREFIX/opt/$_jdk"
      break
    fi
  done; unset _jdk
  # libpq: psql. rustup: keg-only because it conflicts with the `rust` formula;
  # the toolchain it installs lands in ~/.cargo/bin, already on PATH below.
  for _keg in libpq rustup; do
    [[ -d "$HOMEBREW_PREFIX/opt/$_keg/bin" ]] && path=("$HOMEBREW_PREFIX/opt/$_keg/bin" $path)
  done; unset _keg
  # building against keg-only libpq (psycopg2, asyncpg, ...)
  [[ -d "$HOMEBREW_PREFIX/opt/libpq/lib/pkgconfig" ]] \
    && export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/libpq/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
  # metasploit omnibus installs here (its cask is disabled; see packages/Brewfile.security)
  [[ -d /opt/metasploit-framework/bin ]] && path=("/opt/metasploit-framework/bin" $path)
fi

# GUI editor CLIs: the app bundles ship them but never put them on PATH
if (( IS_MAC )); then
  for _app in "Visual Studio Code:code" "Cursor:cursor" "Kiro:kiro"; do
    _bin="/Applications/${_app%%:*}.app/Contents/Resources/app/bin"
    [[ -d "$_bin" ]] && path+=("$_bin")
  done; unset _app _bin
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
export WORDLISTS="$HOME/.local/share/wordlists"       # seclists et al (--security)
export BAT_THEME="gruvbox-dark"

# LS_COLORS (zsh never gets this from /etc/profile on Ubuntu); gnubin provides dircolors on mac
[[ -z "$LS_COLORS" ]] && (( $+commands[dircolors] )) && eval "$(dircolors -b)"
