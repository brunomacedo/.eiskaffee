#!/usr/bin/env bash
# 40-node.sh — Node.js runtime managed entirely by pnpm.
# No Homebrew node, no Corepack, no nvm/fnm/volta: pnpm is installed via its
# own official standalone script (does not require Node.js beforehand) and
# it manages its own Node.js builds internally under
# ~/Library/pnpm/global/ (macOS) or ~/.local/share/pnpm/nodejs/<version>
# (Linux). See https://pnpm.io/installation.
# Per-project version pinning is done via a ".nvmrc" file (name only — no
# relation to nvm) read by the "zsh-auto-pnpm-use" plugin (module 80), which
# calls `pnpm env use --global <version>` automatically on `cd`.
# Also unlinks Homebrew's node when it's only a transitive dependency (e.g.
# of marp-cli) so it doesn't shadow pnpm's node on PATH.
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

# Some Brewfile formulas (e.g. marp-cli) pull Node in as a *dependency*. That
# puts Homebrew's node ahead of pnpm's on PATH and breaks "pnpm-only" Node
# management. Unlink it (keeps it installed for whatever depends on it, just
# not exposed on PATH) — idempotent, safe to run every time. Also guarded
# ongoing by the `zsh-brew-node-guard` plugin (module 80), since a plain
# `brew upgrade` relinks it again without re-running this bootstrap module.
if is_macos && has brew && brew list --formula node >/dev/null 2>&1; then
  if [[ -L "$(brew_prefix)/bin/node" ]] && brew info --formula node 2>/dev/null | grep -q "Installed (as dependency)"; then
    log_info "Unlinking Homebrew's node (installed only as a dependency, e.g. of marp-cli)..."
    run unlink_brew_node_if_dependency \
      && log_ok "Homebrew node unlinked; pnpm's node stays first on PATH." \
      || log_warn "Could not unlink Homebrew node. Run 'brew unlink node' manually."
  else
    log_ok "Homebrew node already unlinked."
  fi
fi

# Node.js itself is managed by pnpm (pnpm env use), replacing nvm/fnm/volta.
# NOTE: this call needs internet access to nodejs.org's release index. Behind
# a corporate proxy (Zscaler/Forcepoint/etc.) it fails with
# UNABLE_TO_GET_ISSUER_CERT_LOCALLY unless NODE_EXTRA_CA_CERTS is set — see
# docs/certificates-macos.md.
log_info "Setting Node.js LTS via 'pnpm env use --global lts'..."
if [[ "${DRY_RUN}" == "1" ]]; then
  log_info "[dry-run] pnpm env use --global lts"
else
  set +e
  NODE_ENV_OUTPUT="$(pnpm env use --global lts 2>&1)"
  NODE_ENV_STATUS=$?
  set -e
  if [[ $NODE_ENV_STATUS -eq 0 ]]; then
    log_ok "Node.js LTS activated via pnpm env ($(node --version 2>/dev/null || echo 'n/a'))"
  else
    log_warn "Failed to activate Node.js LTS via pnpm. Output:"
    echo "$NODE_ENV_OUTPUT" | sed 's/^/      /'
    if echo "$NODE_ENV_OUTPUT" | grep -q "UNABLE_TO_GET_ISSUER_CERT_LOCALLY"; then
      log_warn "Looks like a corporate TLS proxy (Zscaler/Forcepoint/...) is intercepting the connection."
      log_warn "Set NODE_EXTRA_CA_CERTS to your CA bundle and re-run — see docs/certificates-macos.md."
    fi
  fi
fi

log_ok "pnpm ready: $(pnpm --version 2>/dev/null || echo 'n/a')"

# The Node.js build that "pnpm env use"/"pnpm runtime set" installs only ships
# the `node` binary (it comes from the npm "node" package, a bare wrapper —
# unlike the official nodejs.org tarball, which bundles npm under
# lib/node_modules/npm). Without this, `npm` is missing entirely after a
# fresh shell. Install it as its own pnpm-global package so it resolves from
# the same PNPM_HOME/bin on PATH.
if ! has npm; then
  log_info "Installing npm globally via pnpm (pnpm's Node build doesn't bundle it)..."
  run pnpm add -g npm >/dev/null 2>&1 \
    && log_ok "npm installed via pnpm ($(npm --version 2>/dev/null || echo 'n/a'))." \
    || log_warn "Could not install npm via pnpm. Run 'pnpm add -g npm' manually."
else
  log_ok "npm already available ($(npm --version 2>/dev/null || echo 'n/a'))."
fi

log_info "Per-project pin: create a .nvmrc with the Node version (e.g. '24.19.0')."
log_info "The 'zsh-auto-pnpm-use' plugin (module 80) auto-switches it via 'pnpm env use' on cd."
