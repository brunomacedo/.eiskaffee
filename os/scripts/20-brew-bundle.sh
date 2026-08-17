#!/usr/bin/env bash
# 20-brew-bundle.sh — installs the packages from the Brewfile.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"
load_brew

BREWFILE="${SCRIPT_DIR}/../brew/Brewfile"
if ! has brew; then
  if [[ "${DRY_RUN}" == "1" ]]; then
    log_warn "Homebrew not installed yet — in dry-run, only simulating the bundle."
  else
    log_error "Homebrew not found. Run the 10-brew.sh module first."
    exit 1
  fi
fi

log_info "Applying Brewfile (brew bundle)..."
run brew bundle --file="$BREWFILE"
log_ok "Brewfile packages installed/updated."
