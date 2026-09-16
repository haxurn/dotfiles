#!/usr/bin/env bash
# End-to-end smoke test on a clean Ubuntu 24.04 container: apt path + every GitHub fallback.
# Usage: scripts/docker-smoke.sh [image]   (default ubuntu:24.04; try arm64v8/ubuntu:24.04 with binfmt)
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE="${1:-ubuntu:24.04}"

docker run --rm -t -v "$ROOT:/src:ro" "$IMAGE" bash -c '
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq >/dev/null && apt-get install -y -qq git curl ca-certificates sudo locales >/dev/null
cp -r /src /root/dotfiles && cd /root/dotfiles
echo "### first run"
./setup.sh --all -y
echo "### asserts"
for l in ~/.zshrc ~/.p10k.zsh ~/.config/nvim ~/.config/tmux/tmux.conf ~/.gitconfig ~/.config/kitty ~/.config/lazygit; do
  [ -L "$l" ] || { echo "NOT A SYMLINK: $l"; exit 1; }
done
[ -f ~/.zshrc.local ] && [ -f ~/.gitconfig.local ] && [ -f ~/.config/btop/btop.conf ]
DOTFILES_NO_TMUX=1 zsh -ic "alias ls >/dev/null; bindkey | grep -q fzf-history-widget && echo FZF-OK; whence -w mkcd"
tmux -f ~/.config/tmux/tmux.conf new -d "sleep 2"; tmux display -p "#{default-shell}" | grep -q zsh && echo TMUX-SHELL-OK; tmux kill-server
nvim --headless +q && echo NVIM-OK
nvim --version | head -1; lazygit --version | head -1; delta --version; tree-sitter --version; bat --version; eza --version | head -1
git config --get core.pager
echo "### second run (must be idempotent: only linked:/exists:/present:)"
./setup.sh --all -y --no-packages | tee /tmp/second.log
! grep -q "backed up" /tmp/second.log && echo IDEMPOTENT-OK
echo SMOKE-OK'
