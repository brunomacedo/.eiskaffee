#!/usr/bin/env bash
# guard-brew-node.sh — re-applies the "unlink Homebrew's dependency-only
# node" fix from 40-node.sh after any `brew` command that can relink
# formulas (upgrade/update/reinstall/bundle/link/install). Meant to be
# called by the `zsh-brew-node-guard` plugin (module 80) right after a real
# `brew` invocation, not run standalone as part of bootstrap.
#
# Silent when there's nothing to do; prints one line only when it actually
# unlinks something, so it doesn't add noise to routine `brew` usage.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"

is_macos && has brew || exit 0
brew list --formula node >/dev/null 2>&1 || exit 0

# Only worth checking if node is currently linked (unlink_brew_node_if_dependency
# already no-ops otherwise, but checking here avoids a `brew info` shell-out
# on every brew command when there's nothing to do).
[[ -L "$(brew_prefix)/bin/node" ]] || exit 0

if unlink_brew_node_if_dependency; then
  log_ok "Homebrew relinked its dependency-only node — unlinked it again so pnpm's node stays first on PATH."
fi
