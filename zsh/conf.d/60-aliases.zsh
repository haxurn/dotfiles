# 60-aliases

# navigation / listing
if (( $+commands[eza] )); then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza --icons -lh --group-directories-first --git"
  alias la="eza --icons -lah --group-directories-first --git"
  alias lst="eza --icons --tree --level=3"
  alias l.="eza --icons -d .*"
elif (( IS_MAC )); then
  alias ls="ls -G"; alias ll="ls -lhG"; alias la="ls -lahG"
else
  alias ls="ls --color=auto"; alias ll="ls -lh --color=auto"; alias la="ls -lah --color=auto"
fi
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# utils
(( $+commands[bat] )) && alias cat="bat --style=plain"
alias cls="clear"
alias grep="grep --color=auto"
alias mkdir="mkdir -p"
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"
alias df="df -h"
alias dus='du -sh * 2>/dev/null | sort -h'
alias myip="curl -s ifconfig.me"
alias weather="curl -s 'wttr.in/?format=3'"
alias path='echo $PATH | tr ":" "\n" | nl'
alias top="btop 2>/dev/null || htop 2>/dev/null || top"
alias urlenc='jq -sRr @uri'
alias b64d='base64 -d'

# OS-specific glue
if (( IS_MAC )); then
  alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
else
  (( $+commands[xdg-open] )) && alias open="xdg-open"
  if (( $+commands[wl-copy] )) && [[ -n "$WAYLAND_DISPLAY" ]]; then
    alias pbcopy="wl-copy"; alias pbpaste="wl-paste"
  elif (( $+commands[xclip] )); then
    alias pbcopy="xclip -selection clipboard"; alias pbpaste="xclip -selection clipboard -o"
  fi
fi

# git
alias g="git"
alias gs="git status -sb"
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
alias lg="lazygit"

# dev
alias v="nvim"
alias py="python3"
alias serve="python3 -m http.server"
alias zshrc="nvim ~/.zshrc"
alias zlocal="nvim ~/.zshrc.local"
alias reload="exec zsh"
alias nx="pnpm nx"
alias ts="$HOME/.config/tmux/scripts/sessionizer.sh"

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

# ctf: shared solve-script venv (pwntools + pycryptodome + sympy + gmpy2 + z3 ...)
# created by --security (ensure_ctf_venv). `ctf` = python in that env; `ctf-on`
# activates it in the current shell.
if [[ -x "$HOME/.venvs/ctf/bin/python" ]]; then
  alias ctf="$HOME/.venvs/ctf/bin/python"
  alias ctf-on="source $HOME/.venvs/ctf/bin/activate"
fi
