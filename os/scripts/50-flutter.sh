#!/usr/bin/env bash
# 50-flutter.sh — Flutter via FVM (Flutter Version Management).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"
load_brew

# FVM installed via the official Homebrew tap.
if has fvm; then
  log_ok "FVM already installed: $(fvm --version 2>/dev/null || echo 'n/a')"
else
  log_info "Installing FVM..."
  run brew tap leoafarias/fvm >/dev/null 2>&1 || true
  run brew install fvm
fi

# Install/activate Flutter stable through FVM (idempotent).
if has fvm; then
  log_info "Installing the Flutter stable channel via FVM..."
  run fvm install stable >/dev/null 2>&1 || true
  run fvm global stable >/dev/null 2>&1 \
    && log_ok "Flutter stable set as global in FVM" \
    || log_warn "Set it manually: fvm global stable"
  log_info "Add to PATH: export PATH=\"\$HOME/fvm/default/bin:\$PATH\""
fi
