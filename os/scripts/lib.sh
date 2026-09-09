#!/usr/bin/env bash
# =============================================================================
# lib.sh — shared utility functions used by the setup modules.
# Do not run directly; use via `source`.
# =============================================================================

# --- Logging -----------------------------------------------------------------
_c_reset="\033[0m"; _c_blue="\033[34m"; _c_green="\033[32m"
_c_yellow="\033[33m"; _c_red="\033[31m"; _c_bold="\033[1m"

log_section() { printf "\n${_c_bold}${_c_blue}==> %s${_c_reset}\n" "$*"; }
log_info()    { printf "    %s\n" "$*"; }
log_ok()      { printf "${_c_green}    ✓ %s${_c_reset}\n" "$*"; }
log_warn()    { printf "${_c_yellow}    ⚠ %s${_c_reset}\n" "$*"; }
log_error()   { printf "${_c_red}    ✗ %s${_c_reset}\n" "$*" >&2; }

# --- Dry-run -----------------------------------------------------------------
# If DRY_RUN=1, commands passed to run() are only printed, not executed.
: "${DRY_RUN:=0}"

# run <command...> — executes (or, in dry-run, only prints) a command with side
# effects. The dry-run message is sent to the terminal (/dev/tty) so it is not
# suppressed by module redirections (e.g. `run cmd >/dev/null 2>&1`).
run() {
  if [[ "${DRY_RUN}" == "1" ]]; then
    printf "${_c_yellow}    [dry-run] %s${_c_reset}\n" "$*" >/dev/tty 2>/dev/null \
      || printf "${_c_yellow}    [dry-run] %s${_c_reset}\n" "$*"
    return 0
  fi
  "$@"
}

# --- OS detection ------------------------------------------------------------
os_name() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)  echo "linux" ;;
    *)      echo "unknown" ;;
  esac
}
is_macos() { [[ "$(os_name)" == "macos" ]]; }
is_linux() { [[ "$(os_name)" == "linux" ]]; }

# --- Helpers -----------------------------------------------------------------
has() { command -v "$1" >/dev/null 2>&1; }

# Homebrew prefix by OS/architecture.
brew_prefix() {
  if is_macos; then
    [[ "$(uname -m)" == "arm64" ]] && echo "/opt/homebrew" || echo "/usr/local"
  else
    echo "/home/linuxbrew/.linuxbrew"
  fi
}

# Loads brew into the current environment (idempotent).
load_brew() {
  local prefix; prefix="$(brew_prefix)"
  if [[ -x "${prefix}/bin/brew" ]]; then
    eval "$(${prefix}/bin/brew shellenv)"
  fi
}

# Unlinks Homebrew's `node` when it is installed only as a *dependency* of
# another formula (e.g. `marp-cli`), so it doesn't shadow pnpm's own Node on
# PATH. `brew upgrade`/`update`/`reinstall`/`bundle` relink every formula's
# binaries, including dependency-only ones, so this needs to run again after
# any of those — not just once during bootstrap. Idempotent and silent-safe;
# callers decide whether to show output. Returns 0 whether or not anything
# was unlinked (nothing to do is not an error).
unlink_brew_node_if_dependency() {
  is_macos && has brew || return 0
  brew list --formula node >/dev/null 2>&1 || return 0
  brew info --formula node 2>/dev/null | grep -q "Installed (as dependency)" || return 0
  [[ -L "$(brew_prefix)/bin/node" ]] || return 0
  brew unlink node >/dev/null 2>&1
}
