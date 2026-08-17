#!/usr/bin/env bash
# 40-node.sh — Node.js runtime managed entirely by pnpm.
# No Homebrew node, no Corepack, no nvm/fnm/volta: pnpm is installed via its
# own official standalone script (does not require Node.js beforehand) and
# it manages its own Node.js builds internally under
# ~/.local/share/pnpm/nodejs/<version>. See https://pnpm.io/installation.
# Per-project version pinning is done via a ".nvmrc" file (name only — no
# relation to nvm) read by the "zsh-auto-pnpm-use" plugin (module 80), which
# calls `pnpm env use --global <version>` automatically on `cd`.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"

if ! has pnpm; then
  log_info "Installing pnpm via the standalone script (get.pnpm.io)..."
  run bash -c 'curl -fsSL https://get.pnpm.io/install.sh | sh -'
else
  log_ok "pnpm already installed ($(pnpm --version 2>/dev/null))."
fi

# Make sure PNPM_HOME is on PATH for the rest of this script/session (the
# installer also writes this block to ~/.zshrc on its own — see
# docs/zsh-terminal.md for the exact snippet, kept there for reference).
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

if ! has pnpm; then
  log_warn "pnpm still not found on PATH. Open a new shell and re-run this module."
  exit 0
fi

# Node.js itself is managed by pnpm (pnpm env use), replacing nvm/fnm/volta.
log_info "Setting Node.js LTS via 'pnpm env use --global lts'..."
run pnpm env use --global lts >/dev/null 2>&1 \
  && log_ok "Node.js LTS activated via pnpm env ($(node --version 2>/dev/null || echo 'n/a'))" \
  || log_warn "Manual step: pnpm env use --global lts"

log_ok "pnpm ready: $(pnpm --version 2>/dev/null || echo 'n/a')"
log_info "Per-project pin: create a .nvmrc with the Node version (e.g. '24.19.0')."
log_info "The 'zsh-auto-pnpm-use' plugin (module 80) auto-switches it via 'pnpm env use' on cd."
