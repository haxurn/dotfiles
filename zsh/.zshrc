# ── Powerlevel10k instant prompt (must be first) ────────────────────────────
if [[ -t 1 && -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load powerlevel10k early (required for instant prompt to work)
if [[ -r "$HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme"
fi

# ── Shell path setup ────────────────────────────────────────────────────────
typeset -U path PATH fpath

path=(
  "$HOME/bin"
  "$HOME/Android/Sdk/emulator"
  "$HOME/Android/Sdk/platform-tools"
  "$HOME/Android/Sdk/cmdline-tools/latest/bin"
  "$HOME/tools/dex2jar/bin"
  "$HOME/tools/jadx/bin"
  "$HOME/.bun/bin"
  "$HOME/.local/share/fnm"
  "$HOME/go/bin"
  "$HOME/.opencode/bin"
  "$HOME/.local/bin"
  "/usr/local/go/bin"
  $path
)

# ── Detect terminal type early (before tmux auto-start) ───────────────────
_detect_terminal() {
  # Check if already in tmux
  [[ -n "$TMUX" ]] && echo "tmux" && return
  
  # Check TERM_PROGRAM
  [[ "$TERM_PROGRAM" == "Warp" ]] && echo "warp" && return
  [[ "$TERM_PROGRAM" == "kiro" ]] && echo "kiro" && return
  [[ "$TERM_PROGRAM" == "vscode" ]] && echo "vscode" && return
  
  # Check parent process tree for Warp
  local parent parent_pid=$$
  while [[ $parent_pid -gt 1 ]]; do
    parent=$(ps -p $parent_pid -o comm= 2>/dev/null)
    [[ -z "$parent" ]] && break
    [[ "$parent" == "Warp" ]] && echo "warp" && return
    parent_pid=$(ps -o ppid= -p $parent_pid 2>/dev/null | tr -d ' ')
    [[ "$parent_pid" == "1" ]] && break
  done
  
  echo "unknown"
}

# Auto-start tmux (disabled for Warp, Kiro, VSCode - they manage their own windows)
if [[ -o interactive && -t 0 && -t 1 && -z "$TMUX" && -z "$VSCODE_INJECTION" ]]; then
  # Detect terminal type once and cache it
  case "$(_detect_terminal)" in
    warp|kiro|vscode)
      # Skip - these terminals handle their own session management
      ;;
    *)
      tmux new-session -A -s main
      ;;
  esac
fi

# ── Oh My Zsh ────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
# Note: powerlevel10k is loaded early above (required for instant prompt)
ZSH_THEME=""  # Prevent OMZ from loading its own theme

plugins=(
  git
  docker
  docker-compose
  npm
  node
  golang
  colored-man-pages
  command-not-found
  extract
  sudo
  jsontools
  web-search
  copypath
  copyfile
  dirhistory
  fzf-tab
  zsh-completions
)

# Extra completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source "$ZSH/oh-my-zsh.sh"

# ── Local secrets ───────────────────────────────────────────────────────────
[[ -r "$HOME/.config/secrets/supermemory.env" ]] && source "$HOME/.config/secrets/supermemory.env"

# ── History ──────────────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS HIST_VERIFY INC_APPEND_HISTORY EXTENDED_HISTORY

# ── Editor ───────────────────────────────────────────────────────────────────
export EDITOR='nvim'
export VISUAL='nvim'

# ── Aliases ──────────────────────────────────────────────────────────────────

# navigation
alias ls="eza --icons --group-directories-first"
alias ll="eza --icons -lh --group-directories-first --git"
alias la="eza --icons -lah --group-directories-first --git"
alias lst="eza --icons --tree --level=3"
alias l.="eza --icons -d .*"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# utils
alias cat="bat --style=plain"
alias cls="clear"
alias grep="grep --color=auto"
alias mkdir="mkdir -p"
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"
alias df="df -h"
alias du="du -sh"
alias ports="ss -tulnp"
alias myip="curl -s ifconfig.me"
alias weather="curl -s wttr.in/?format=3"
alias path='echo $PATH | tr ":" "\n" | nl'
alias top="btop 2>/dev/null || htop 2>/dev/null || top"

# git
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate --all"
alias gst="git stash"
alias gstp="git stash pop"
alias gcp="git cherry-pick"
alias grb="git rebase"
alias gwip="git add -A && git commit -m 'wip: work in progress [skip ci]'"

# dev
alias v="nvim"
alias py="python3"
alias serve="python3 -m http.server"
alias zshrc="nvim ~/.zshrc"
alias reload="exec zsh"
alias nx="pnpm nx"

# docker
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dpa="docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dlog="docker logs -f"
alias dex="docker exec -it"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"

# nix
alias ne="nix develop"
alias nb="nix build"
alias nf="nix flake"
alias ns="nix search nixpkgs"

# ── fzf configuration ───────────────────────────────────────────────────────
export FZF_DEFAULT_OPTS="
  --height=60%
  --layout=reverse
  --border=rounded
  --info=inline-right
  --prompt='   '
  --pointer=''
  --marker=''
  --separator='─'
  --scrollbar='│'
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#a6e3a1,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --color=border:#45475a,separator:#45475a,scrollbar:#45475a
:"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || eza --icons --tree --level=2 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons --tree --level=2 {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview'"

# fzf-tab configuration
zstyle ':fzf-tab:*' fzf-flags --height=60% --layout=reverse --border=rounded
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons --tree --level=2 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza --icons --tree --level=2 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:200 $realpath 2>/dev/null || eza --icons --tree --level=2 --color=always $realpath 2>/dev/null'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# ── Nix ──────────────────────────────────────────────────────────────────────
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# ── PATH ─────────────────────────────────────────────────────────────────────
export GOPATH="$HOME/go"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
path=("$PNPM_HOME" $path)

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  path=("$FNM_PATH" $path)
  eval "$(fnm env --shell zsh)"
fi

# bun
export BUN_INSTALL="$HOME/.bun"
path=("$BUN_INSTALL/bin" $path)
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Android SDK
export ANDROID_HOME="$HOME/Android/Sdk"
alias start-android='nohup emulator -avd Pixel_9_Pro_XL -gpu swiftshader_indirect -no-snapshot-load -wipe-data > ~/emulator.log 2>&1 &'

# ── Kiro + Warp shell integration ────────────────────────────────
# Kiro
if [[ "$TERM_PROGRAM" == "kiro" ]] && (( $+commands[kiro] )); then
  kiro_integration="$(kiro --locate-shell-integration-path zsh)"
  [[ -r "$kiro_integration" ]] && source "$kiro_integration"
  unset kiro_integration
fi

# Warp terminal - use _detect_terminal for detection that works inside tmux too
if [[ "$(_detect_terminal)" == "warp" || "$TERM_PROGRAM" == "Warp" ]]; then
  export TERM=xterm-256color
  export COLORTERM=truecolor
  # Warp-specific: improve shell integration performance
  export PROMPT_EOL_MARK=''
fi

# ── lockenv completions ─────────────────────────────────────────────────────
if (( $+commands[lockenv] )); then
  source <(lockenv completion zsh | head -n -1)
  compdef _lockenv lockenv
fi

# ── Powerlevel10k config ─────────────────────────────────────────────────────
[[ -t 1 && -r ~/.p10k.zsh ]] && source ~/.p10k.zsh

# >>> forge initialize >>>
# !! Contents within this block are managed by 'forge zsh setup' !!
# !! Do not edit manually - changes will be overwritten !!

# Add required zsh plugins if not already present
if [[ ! " ${plugins[@]} " =~ " zsh-autosuggestions " ]]; then
    plugins+=(zsh-autosuggestions)
fi
if [[ ! " ${plugins[@]} " =~ " zsh-syntax-highlighting " ]]; then
    plugins+=(zsh-syntax-highlighting)
fi

# Load forge shell plugin (commands, completions, keybindings) if not already loaded
if [[ -z "$_FORGE_PLUGIN_LOADED" ]]; then
    eval "$(forge zsh plugin)"
fi

# Load forge shell theme (prompt with AI context) if not already loaded
if [[ -z "$_FORGE_THEME_LOADED" ]]; then
    eval "$(forge zsh theme)"
fi

# Editor for editing prompts (set during setup)
# To change: update FORGE_EDITOR or remove to use $EDITOR
export FORGE_EDITOR="nvim"
# <<< forge initialize <<<

# ── Zoxide (smarter cd) ─────────────────────────────────────────────────────
# _ZO_DOCTOR=0 silences the p10k instant-prompt false-positive warning.
export _ZO_DOCTOR=0
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"

alias claude-mem='bun "/home/haxurn/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'

# OpenClaw Completion
[[ -r "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"

# ── Final interactive plugins ───────────────────────────────────────────────
if [[ -r "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Forge registers its own pattern highlighter before zsh-syntax-highlighting is
# loaded. Keep it, but ensure the normal command parser remains enabled too.
typeset -ga ZSH_HIGHLIGHT_HIGHLIGHTERS
if (( ${ZSH_HIGHLIGHT_HIGHLIGHTERS[(Ie)main]} == 0 )); then
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main $ZSH_HIGHLIGHT_HIGHLIGHTERS)
fi

if [[ -r "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi