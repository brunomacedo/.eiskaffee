# zsh-brew-node-guard — keeps pnpm's Node ahead of Homebrew's on PATH.
#
# Context: some Brewfile formulas (e.g. marp-cli) pull `node` in as a
# transitive *dependency*. Homebrew links it into $(brew --prefix)/bin
# whenever it installs OR relinks formulas — which happens on plain
# `brew upgrade`/`update`/`reinstall`/`bundle`, not just on first install.
# That silently shadows pnpm's own Node (see os/scripts/40-node.sh), even
# though 40-node.sh already unlinked it once during bootstrap.
#
# This plugin wraps the `brew` command: after any subcommand that can
# relink formulas, it re-runs the same unlink check non-interactively.
# Cloned/symlinked by module 80-zsh-plugins.sh; add "zsh-brew-node-guard" to
# ~/.zshrc's plugins=(...) — see os/docs/zsh-terminal.md.

brew() {
  command brew "$@"
  local brew_exit=$?

  case "$1" in
    upgrade|update|reinstall|bundle|install|link)
      local guard="${EISK_HOME:-$HOME/.eiskaffee}/os/scripts/guard-brew-node.sh"
      [[ -x "$guard" ]] && bash "$guard"
      ;;
  esac

  return $brew_exit
}
