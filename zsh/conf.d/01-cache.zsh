# 01-cache: cache the output of slow `tool init zsh` calls.
# _cached_eval <name> <cmd...> runs cmd once, saves its output to
# ~/.cache/zsh/eval/<name>.zsh (compiled), and sources that file on later
# startups instead of forking the tool. The cache rebuilds when the tool's
# resolved binary changes (brew upgrade moves it to a new Cellar path) or is
# newer than the cache. `zcache-clear` drops everything.
_ZSH_EVAL_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/eval"

_cached_eval() {
  local name=$1; shift
  local bin=${commands[$1]}
  [[ -n $bin ]] || return 1
  local f="$_ZSH_EVAL_CACHE/$name.zsh" stamp="# bin: ${bin:A}"
  if [[ ! -s $f || $bin -nt $f || "$(head -1 "$f" 2>/dev/null)" != "$stamp" ]]; then
    mkdir -p "$_ZSH_EVAL_CACHE"
    { print -r -- "$stamp"; "$@" 2>/dev/null } >| "$f" || { rm -f "$f"; return 1 }
    zcompile "$f" 2>/dev/null
  fi
  source "$f"
}

zcache-clear() {
  rm -rf "$_ZSH_EVAL_CACHE"
  print "eval cache cleared; open a new shell to rebuild it"
}
