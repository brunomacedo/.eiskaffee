#!/usr/bin/env bash
# 80-zsh-plugins.sh — Oh My Zsh custom theme + plugins used with Eiskaffee.
# Does NOT touch ~/.zshrc automatically (avoids clobbering machine-specific
# env vars/secrets). See os/docs/zsh-terminal.md for the
# `plugins=(...)` snippet to add by hand.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"

ZSH_CUSTOM_DEFAULT="${HOME}/.oh-my-zsh/custom"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH_CUSTOM_DEFAULT}"

if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  log_warn "Oh My Zsh not found. Run module 60-dotfiles first."
  exit 0
fi

run mkdir -p "${ZSH_CUSTOM}/themes" "${ZSH_CUSTOM}/plugins"

# --- Eiskaffee theme (symlink to the theme versioned in this repo) ----------
THEME_SRC="${EISK_HOME:-$HOME/.eiskaffee}/.oh-my-zsh/eiskaffee.zsh-theme"
THEME_DEST="${ZSH_CUSTOM}/themes/eiskaffee.zsh-theme"
if [[ -f "$THEME_SRC" ]]; then
  if [[ -L "$THEME_DEST" || -f "$THEME_DEST" ]]; then
    log_ok "eiskaffee.zsh-theme already linked."
  else
    run ln -s "$THEME_SRC" "$THEME_DEST"
    log_ok "eiskaffee.zsh-theme linked."
  fi
else
  log_warn "Theme not found at ${THEME_SRC} (is EISK_HOME set correctly?)."
fi

# --- Plugin: zsh-autosuggestions (third-party, public) ----------------------
clone_plugin() {
  local repo="$1" dest="$2"
  if [[ -d "$dest" ]]; then
    log_ok "$(basename "$dest") already present."
  else
    log_info "Cloning $(basename "$dest")..."
    run git clone --depth=1 "$repo" "$dest"
  fi
}

clone_plugin "https://github.com/zsh-users/zsh-autosuggestions" \
  "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"

# --- Plugin: zsh-auto-pnpm-use (own repo) -----------------------------------
clone_plugin "https://github.com/brunomacedo/zsh-auto-pnpm-use" \
  "${ZSH_CUSTOM}/plugins/zsh-auto-pnpm-use"

# --- Plugin: zsh-brew-node-guard (own plugin, versioned in this repo) -------
# Symlinked (not cloned) since it lives in .oh-my-zsh/ of this repo, same as
# the eiskaffee theme — keeps it in sync automatically on `eiskaffee update`.
GUARD_SRC="${EISK_HOME:-$HOME/.eiskaffee}/.oh-my-zsh/zsh-brew-node-guard"
GUARD_DEST="${ZSH_CUSTOM}/plugins/zsh-brew-node-guard"
if [[ -d "$GUARD_SRC" ]]; then
  if [[ -L "$GUARD_DEST" || -d "$GUARD_DEST" ]]; then
    log_ok "zsh-brew-node-guard already linked."
  else
    run ln -s "$GUARD_SRC" "$GUARD_DEST"
    log_ok "zsh-brew-node-guard linked."
  fi
else
  log_warn "zsh-brew-node-guard not found at ${GUARD_SRC} (is EISK_HOME set correctly?)."
fi

log_ok "Zsh theme/plugins ready."
log_info "Now add the 'plugins=(...)' snippet to ~/.zshrc — see os/docs/zsh-terminal.md"
