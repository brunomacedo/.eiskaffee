#!/usr/bin/env bash
# 30-vscode.sh — installs VS Code extensions (idempotent, OPT-IN).
# This module does NOT run in the default bootstrap. VS Code is synced through
# the Microsoft account (Settings Sync), so extensions arrive on their own after
# signing in. Run it manually only if needed: ./scripts/bootstrap.sh 30
#   (or ./scripts/bootstrap.sh --with-vscode to include it in the full flow).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"

if ! has code; then
  log_warn "Command 'code' not found. Open VS Code and run "
  log_warn "  'Shell Command: Install code command in PATH' (Cmd+Shift+P)."
  exit 0
fi

EXT_FILE="${SCRIPT_DIR}/../vscode/extensions.txt"
installed="$(code --list-extensions 2>/dev/null || true)"

while IFS= read -r ext; do
  [[ -z "$ext" || "$ext" == \#* ]] && continue
  if grep -qix "$ext" <<< "$installed"; then
    log_ok "already installed: $ext"
  else
    log_info "installing: $ext"
    run code --install-extension "$ext" --force >/dev/null
  fi
done < "$EXT_FILE"

log_ok "VS Code extensions synced."
