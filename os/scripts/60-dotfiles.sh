#!/usr/bin/env bash
# 60-dotfiles.sh — guides the dotfiles (.eiskaffee) installation.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"

# Oh My Zsh (base for theme/plugins).
if [[ -d "${HOME}/.oh-my-zsh" ]]; then
  log_ok "Oh My Zsh already installed."
else
  log_info "Installing Oh My Zsh..."
  run sh -c \
    "RUNZSH=no CHSH=no sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
fi

log_section "Dotfiles"
log_info "1. The dotfiles live in the .eiskaffee repository (this project is under os/)."
log_info "2. Copy/symlink your shell files following your own convention."
log_info "3. Corporate certificates: see os/docs/certificates-macos.md"
log_info "4. Other sensitive artifacts (SSH keys, Samsung certificates, etc.): see os/docs/secrets.md"
