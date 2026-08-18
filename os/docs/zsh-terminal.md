# Zsh & Ghostty terminal setup

This machine's terminal stack: **Ghostty** (emulator) + **Zsh** + **Oh My Zsh** with the custom `eiskaffee` theme and a couple of plugins.

## Ghostty

Module `scripts/70-ghostty.sh` installs Ghostty (formula on Linux, cask on macOS) and copies the versioned config from [`dotfiles/ghostty/config`](../dotfiles/ghostty/config) to the right path:

- Linux: `~/.config/ghostty/config`
- macOS: `~/Library/Application Support/com.mitchellh.ghostty/config`

If a different config already exists at the destination, it is backed up to `config.bak` before being overwritten. The versioned file only carries appearance settings (theme, opacity, blur) — safe to keep public.

## Node.js (managed entirely by pnpm — no nvm/fnm/volta/Homebrew node)

Module `scripts/40-node.sh` reproduces this machine's real setup:

1. Installs **pnpm** via its official standalone script (`curl -fsSL https://get.pnpm.io/install.sh | sh -`) — this does **not** require Node.js to be installed beforehand, and does **not** go through Homebrew or Corepack.
2. Unlinks Homebrew's `node` if it is present only **as a dependency** of another formula (e.g. `marp-cli` pulls it in transitively). This keeps it installed for whatever needs it, but off `PATH`, so pnpm's own Node stays the one resolved by `node`/`npx`/etc. Idempotent — safe to re-run.
3. pnpm manages its own Node.js builds internally, under `~/Library/pnpm/global/` (see `pnpm env list` / `pnpm env use --global <version>`).
4. Sets a global default with `pnpm env use --global lts`.
5. Installs **npm** itself as a plain pnpm-global package (`pnpm add -g npm`). The Node build that `pnpm env use` fetches only ships the `node` binary — it comes from the npm [`node`](https://www.npmjs.com/package/node) wrapper package, unlike the official nodejs.org tarball, which bundles `npm` under `lib/node_modules/npm`. Without this step `npm` is missing entirely (`npm is not installed.` on every new shell) even though `node` works fine.

Per-project version pinning uses a `.nvmrc` file at the project root (just the version number, e.g. `24.19.0`). **The name is only a naming convention — it has no relation to nvm.** It is read exclusively by the `zsh-auto-pnpm-use` plugin below, which calls `pnpm env use --global <version>` for you.

> ⚠️ **Behind a corporate TLS proxy** (Zscaler/Forcepoint/etc.), `pnpm env use` needs to fetch `https://nodejs.org/download/release/index.json` and will fail with `UNABLE_TO_GET_ISSUER_CERT_LOCALLY` unless `NODE_EXTRA_CA_CERTS` (and friends) point to your CA bundle — see [`certificates-macos.md`](./certificates-macos.md). Without it, `40-node.sh` silently leaves Node.js unmanaged by pnpm and `node` may resolve to whatever Homebrew installed as a side dependency instead.

### The `zsh-auto-pnpm-use` plugin

Own plugin ([`brunomacedo/zsh-auto-pnpm-use`](https://github.com/brunomacedo/zsh-auto-pnpm-use)), cloned automatically by module `80-zsh-plugins.sh`. On every `cd` (via a zsh `precmd` hook) it:

- Remembers the "default" Node version active in the shell session (`AUTO_PNPM_DEFAULT_NODE_VERSION`).
- If the new directory has a `.nvmrc`, runs `pnpm env use --global <version-from-file>` and prints `Node.js <version> is activated`.
- If the directory has no `.nvmrc`, reverts to the session's default version and prints `Reverting to default node version <version>`.

It intentionally does **not** use `pnpm config set/get default-node-version` (that key was removed by pnpm and is not documented in [pnpm settings](https://pnpm.io/settings)) — a plain shell variable is used instead, to avoid the `ERR_PNPM_CONFIG_SET_UNSUPPORTED_YAML_CONFIG_KEY` warning.

## Zsh (Oh My Zsh theme + plugins)

Module `scripts/80-zsh-plugins.sh` is idempotent and:

1. Symlinks `.oh-my-zsh/eiskaffee.zsh-theme` (versioned in this repo) into `$ZSH_CUSTOM/themes/`.
2. Clones the plugins used in this setup, if missing:
   - [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) (third-party)
   - [`zsh-auto-pnpm-use`](https://github.com/brunomacedo/zsh-auto-pnpm-use) (own plugin)

It does **not** touch `~/.zshrc` automatically — that file is machine-specific and may contain corporate env vars/tokens that must never be scripted/versioned (see [`secrets.md`](./secrets.md)). Add this manually after running the module:

```sh
ZSH_THEME="eiskaffee"

plugins=(
  git
  zsh-autosuggestions
  zsh-auto-pnpm-use
)
```

### Other `~/.zshrc` snippets to bring over by hand

These are safe to copy as-is (no secrets). The `pnpm` block below is usually appended automatically by the standalone installer (module `40-node.sh`) on first run — check if it's already there before pasting a duplicate:

```sh
# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="$HOME/fvm/bin:$PATH"
```

### ⚠️ Never copy these as-is

- `NODE_EXTRA_CA_CERTS` / `REQUESTS_CA_BUNDLE` / `SSL_CERT_FILE` — path changes on macOS, see [`certificates-macos.md`](./certificates-macos.md).
- Any `export SOMETHING_TOKEN="eyJ..."` / API keys / JWTs exported directly in `.zshrc` (e.g. tokens generated by internal CLIs). These are machine-session secrets tied to your corporate identity — regenerate them on the new machine using the tool that created them, never paste the value into a script or commit it.
