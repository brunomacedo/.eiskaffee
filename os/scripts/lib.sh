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
