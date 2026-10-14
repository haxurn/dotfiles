# 85-plugins-extra: quality-of-life plugins. Runs before 90-plugins so
# zsh-syntax-highlighting still loads last.
_src() { [[ -r "$1" ]] && source "$1" }

# you-should-use: reminds you when an alias exists for what you just typed.
export YSU_MESSAGE_POSITION="after"
export YSU_MODE=BESTMATCH
_src "$ZSH_CUSTOM/plugins/you-should-use/you-should-use.plugin.zsh"

# auto-notify: desktop notification when a command runs >= 30s
# (terminal-notifier on macOS, notify-send on Linux).
export AUTO_NOTIFY_THRESHOLD=30
export AUTO_NOTIFY_TITLE="%command finished"
export AUTO_NOTIFY_BODY="took %elapsed s, exit %exit_code"
if _src "$ZSH_CUSTOM/plugins/auto-notify/auto-notify.plugin.zsh"; then
  AUTO_NOTIFY_IGNORE+=(nvim vim v lazygit lg btop htop top ssh tmux man less bat
                       fzf docker-compose "docker compose" k9s claude yazi serve)
fi

# zsh-autopair: auto-close quotes and brackets, delete pairs together.
if _src "$ZSH_CUSTOM/plugins/zsh-autopair/autopair.zsh"; then
  autopair-init
  bindkey '^H' backward-kill-word        # autopair takes ^H; keep ctrl-backspace (50-keybinds)
fi

# zsh-abbr: fish-style abbreviations that expand inline on space/enter, so
# history shows the full command. Loaded after autopair so it owns space.
# Abbreviations live in the repo (zsh/abbreviations); `abbr add x=...` writes there.
export ABBR_USER_ABBREVIATIONS_FILE="$DOTFILES_ZSH/abbreviations"
export ABBR_SET_EXPANSION_CURSOR=1            # `%` in an expansion marks where the cursor lands
export ABBR_GET_AVAILABLE_ABBREVIATION=1      # nudge when an abbr exists for what you typed
export ABBR_LOG_AVAILABLE_ABBREVIATION=1
_src "$ZSH_CUSTOM/plugins/zsh-abbr/zsh-abbr.plugin.zsh"

unfunction _src
