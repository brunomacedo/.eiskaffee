#!/usr/bin/env bash
# 10-brew.sh — installs Homebrew if needed.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"

load_brew
if has brew; then
  log_ok "Homebrew already installed at $(brew --prefix)."
else
  log_info "Installing Homebrew..."
  run /bin/bash -c \
    "NONINTERACTIVE=1 \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  load_brew
fi

# Ensures shellenv is in .zprofile (macOS) for future sessions.
if is_macos; then
  prefix="$(brew_prefix)"
  line="eval \"\$(${prefix}/bin/brew shellenv)\""
  zprofile="${HOME}/.zprofile"
  if ! grep -qsF "$line" "$zprofile" 2>/dev/null; then
    run bash -c "echo '$line' >> '$zprofile'"
    log_ok "brew shellenv added to ~/.zprofile"
  fi
fi

has brew && brew --version | head -n1
