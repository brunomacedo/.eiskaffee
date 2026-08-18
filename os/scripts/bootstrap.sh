#!/usr/bin/env bash
# =============================================================================
# bootstrap.sh — development machine setup orchestrator.
# Linux/macOS agnostic. Idempotent: run it as many times as you want.
#
# Usage:
#   ./scripts/bootstrap.sh                 # run the default set
#   ./scripts/bootstrap.sh --dry-run       # simulate (runs nothing)
#   ./scripts/bootstrap.sh 10 40           # run only modules 10-brew and 40-node
#   ./scripts/bootstrap.sh 30              # run only VS Code (optional, opt-in)
#   ./scripts/bootstrap.sh --with-vscode   # default + VS Code extensions
#
# Note: VS Code extensions (module 30) do NOT run by default, since VS Code is
# synced through the Microsoft account (Settings Sync). Use the "30" prefix or
# the --with-vscode flag to install them manually.
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

# --- Flags -------------------------------------------------------------------
DRY_RUN=0
WITH_VSCODE=0
PREFIXES=()
for arg in "$@"; do
  case "$arg" in
    -n|--dry-run) DRY_RUN=1 ;;
    --with-vscode) WITH_VSCODE=1 ;;
    -h|--help)
      grep '^#' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    *) PREFIXES+=("$arg") ;;
  esac
done
export DRY_RUN

log_section "Development machine bootstrap"
log_info "Detected OS: $(os_name)"
[[ "$DRY_RUN" == "1" ]] && log_warn "DRY-RUN mode: no command will actually be executed."

# Modules that run by default (order matters). 30-vscode is left out.
MODULES=(
  "00-preflight.sh"
  "10-brew.sh"
  "20-brew-bundle.sh"
  "40-node.sh"
  "50-flutter.sh"
  "60-dotfiles.sh"
  "70-ghostty.sh"
  "80-zsh-plugins.sh"
)

# --with-vscode includes the extensions module after brew-bundle.
if [[ "$WITH_VSCODE" == "1" ]]; then
  MODULES=("00-preflight.sh" "10-brew.sh" "20-brew-bundle.sh" "30-vscode.sh" "40-node.sh" "50-flutter.sh" "60-dotfiles.sh" "70-ghostty.sh" "80-zsh-plugins.sh")
fi

# If the user passes prefixes (e.g. 10 40), filter over ALL modules
# (including 30-vscode, so it can be run in isolation with "./bootstrap.sh 30").
if [[ ${#PREFIXES[@]} -gt 0 ]]; then
  ALL=(00-preflight.sh 10-brew.sh 20-brew-bundle.sh 30-vscode.sh 40-node.sh 50-flutter.sh 60-dotfiles.sh 70-ghostty.sh 80-zsh-plugins.sh)
  FILTERED=()
  for prefix in "${PREFIXES[@]}"; do
    for m in "${ALL[@]}"; do
      [[ "$m" == "$prefix"* ]] && FILTERED+=("$m")
    done
  done
  MODULES=("${FILTERED[@]}")
fi

for m in "${MODULES[@]}"; do
  path="${SCRIPT_DIR}/${m}"
  if [[ -f "$path" ]]; then
    log_section "→ ${m}"
    DRY_RUN="$DRY_RUN" bash "$path"
  else
    log_warn "Module not found: ${m} (skipping)"
  fi
done

log_section "Done 🎉"
log_info "Restart the terminal (or run 'exec zsh') to load everything."
[[ "$WITH_VSCODE" == "0" ]] && log_info "VS Code extensions not installed (Settings Sync handles that). Use --with-vscode or './bootstrap.sh 30' if you need them."
