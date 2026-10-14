# 55-forgit: fzf-powered git (interactive add, log, diff, stash, checkout, rebase ...).
# Loaded before 60-aliases so our own short git aliases (ga, gd, gco, gcp, grb)
# win. forgit's versions of those live under an `f` prefix below; its other
# aliases (glo, gcb, gsw, gss, gbd, gbl, grh, gclean, ...) work as documented:
# https://github.com/wfxr/forgit#-features
[[ -r "$ZSH_CUSTOM/plugins/forgit/forgit.plugin.zsh" ]] || return 0
export FORGIT_FZF_DEFAULT_OPTS="--height=80% --preview-window=right,60%"
source "$ZSH_CUSTOM/plugins/forgit/forgit.plugin.zsh"
alias fga='forgit::add'                       # pick files to stage, diff preview
alias fgd='forgit::diff'                      # browse diffs
alias fgco='forgit::checkout::commit'         # check out a commit
alias fgcp='forgit::cherry::pick::from::branch'
alias fgrb='forgit::rebase'                   # pick the commit to rebase from
