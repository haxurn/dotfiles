# 10-tmux: detect host terminal once, auto-start tmux where it makes sense
_detect_terminal() {
  [[ -n "$TMUX" ]] && { echo tmux; return }
  case "$TERM_PROGRAM" in
    Warp)   echo warp;   return ;;
    kiro)   echo kiro;   return ;;
    vscode) echo vscode; return ;;
  esac
  # walk the parent chain for Warp (it does not always set TERM_PROGRAM inside tmux)
  local parent parent_pid=$$
  while [[ $parent_pid -gt 1 ]]; do
    parent=$(ps -p $parent_pid -o comm= 2>/dev/null)
    [[ -z "$parent" ]] && break
    [[ "$parent" == "Warp" ]] && { echo warp; return }
    parent_pid=$(ps -o ppid= -p $parent_pid 2>/dev/null | tr -d ' ')
    [[ "$parent_pid" == "1" ]] && break
  done
  echo unknown
}
export DOTFILES_TERM="${DOTFILES_TERM:-$(_detect_terminal)}"

# Auto-attach "main". Skipped for: ssh, VS Code/Kiro/Warp (own session mgmt), DOTFILES_NO_TMUX=1
if [[ -o interactive && -t 0 && -t 1 && -z "$TMUX" && -z "$SSH_CONNECTION" && -z "$SSH_TTY" \
      && -z "$VSCODE_INJECTION" && -z "$DOTFILES_NO_TMUX" ]] && (( $+commands[tmux] )); then
  case "$DOTFILES_TERM" in
    warp|kiro|vscode) ;;
    *) tmux new-session -A -s main ;;
  esac
fi
