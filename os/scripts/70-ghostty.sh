#!/usr/bin/env bash
# 70-ghostty.sh — installs Ghostty and applies the versioned config (idempotent).
# Config source of truth: os/dotfiles/ghostty/config (public-safe,
# no secrets — just theme/appearance).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"
load_brew

SRC_CONFIG="${SCRIPT_DIR}/../dotfiles/ghostty/config"

if ! has ghostty; then
  if is_macos; then
    log_info "Installing Ghostty (cask)..."
    run brew install --cask ghostty
  elif is_linux; then
    if has brew; then
      log_info "Installing Ghostty via Homebrew..."
      run brew install ghostty
    else
      log_warn "Ghostty not found and Homebrew unavailable. Install manually: https://ghostty.org/download"
    fi
  fi
else
  log_ok "Ghostty already installed."
fi

# Config path differs per OS.
if is_macos; then
  DEST_DIR="${HOME}/Library/Application Support/com.mitchellh.ghostty"
else
  DEST_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
fi
DEST_CONFIG="${DEST_DIR}/config"

run mkdir -p "$DEST_DIR"

if [[ -f "$DEST_CONFIG" ]] && ! cmp -s "$SRC_CONFIG" "$DEST_CONFIG" 2>/dev/null; then
  log_warn "Existing Ghostty config differs from the versioned one. Backing up to ${DEST_CONFIG}.bak"
  run cp "$DEST_CONFIG" "${DEST_CONFIG}.bak"
fi

run cp "$SRC_CONFIG" "$DEST_CONFIG"
log_ok "Ghostty config applied at ${DEST_CONFIG}"
