#!/usr/bin/env bash
# 00-preflight.sh — initial checks and minimum dependencies.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"

if is_macos; then
  # Xcode Command Line Tools (git, compilers) — Homebrew prerequisite.
  if ! xcode-select -p >/dev/null 2>&1; then
    log_info "Installing Xcode Command Line Tools (a window may open)..."
    run xcode-select --install || true
    log_warn "Finish the Xcode CLT installation and run the bootstrap again."
  else
    log_ok "Xcode Command Line Tools present."
  fi
elif is_linux; then
  if ! has curl || ! has git; then
    log_warn "Install 'curl' and 'git' (e.g. sudo apt install -y curl git build-essential)."
  else
    log_ok "curl and git present."
  fi
fi
