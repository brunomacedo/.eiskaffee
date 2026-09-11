# 🖥️ os (machine-setup)

A **reusable, OS-agnostic** project to reproduce the development environment on a new machine (focused on the Linux → macOS migration, but works on both OSes).

The source of truth is declarative (Brewfile + extensions list) and the installation is driven by **idempotent shell scripts** — run them as many times as you want.

> ⚠️ This project lives in the **public** `.eiskaffee` repository. **No secret is versioned here.** See [`docs/secrets.md`](./docs/secrets.md).

## 📦 Structure

```
os/
├── README.md                 # this guide
├── brew/
│   └── Brewfile              # CLI packages + casks (Homebrew)
├── vscode/
│   └── extensions.txt        # VS Code extensions (1 per line)
├── dotfiles/
│   └── ghostty/
│       └── config            # Ghostty config (public-safe: theme/opacity/blur only)
├── scripts/
│   ├── bootstrap.sh          # orchestrator (runs everything, or modules by prefix)
│   ├── lib.sh                # utilities (logging, OS/arch detection)
│   ├── 00-preflight.sh       # prerequisites (Xcode CLT / curl+git)
│   ├── 10-brew.sh            # installs Homebrew
│   ├── 20-brew-bundle.sh     # applies the Brewfile
│   ├── 30-vscode.sh          # VS Code extensions (OPT-IN — see below)
│   ├── 40-node.sh            # pnpm (standalone installer) + Node.js managed via `pnpm env`
│   ├── 50-flutter.sh         # Flutter via FVM
│   ├── 60-dotfiles.sh        # Oh My Zsh + dotfiles guidance
│   ├── 70-ghostty.sh         # Ghostty install + versioned config
│   └── 80-zsh-plugins.sh     # Oh My Zsh eiskaffee theme + plugins (autosuggestions, auto-pnpm-use)
└── docs/
    ├── secrets.md            # sensitive artifacts and how to bring them over
    ├── certificates-macos.md # corporate certificates on macOS
    └── zsh-terminal.md       # Ghostty + Zsh/Oh My Zsh setup details
```

## 🚀 Step by step on the new MacBook

### 1. Install Eiskaffee

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/brunomacedo/.eiskaffee/master/tools/install.sh)"
exec zsh
```

### 2. Run the bootstrap

```sh
eiskaffee bootstrap
```

(equivalent to running `~/.eiskaffee/os/scripts/bootstrap.sh` directly, kept for advanced/manual use).

This runs, in order: prerequisites → Homebrew → Brewfile → Node/pnpm → Flutter/FVM → dotfiles → Ghostty → Zsh theme/plugins.

> 💡 **VS Code extensions are optional.** VS Code is signed into your Microsoft account with **Settings Sync**, so extensions arrive on their own when you open the editor on the new machine. That is why the `30-vscode.sh` module **does not run** in the default flow. To install them manually:
>
> ```sh
> eiskaffee bootstrap --with-vscode   # include in the full flow
> eiskaffee bootstrap 30              # extensions only
> ```

#### 🧪 Dry-run (simulation)

To see **everything the script would do** without actually running anything (no install, write or download), use `--dry-run` (or `-n`):

```sh
eiskaffee bootstrap --dry-run
```

Commands with side effects appear prefixed with `[dry-run]`. It combines with the other flags/prefixes, for example:

```sh
eiskaffee bootstrap --dry-run --with-vscode
eiskaffee bootstrap -n 40 50        # simulate only Node and Flutter
```

To run only some modules (by prefix):

```sh
eiskaffee bootstrap 10 20   # only Homebrew and Brewfile
eiskaffee bootstrap 70 80   # only Ghostty and Zsh theme/plugins
```

### 3. Corporate certificates

Bring the `.crt`/`.pem` files over a secure channel and follow [`docs/certificates-macos.md`](./docs/certificates-macos.md).

### 4. Finish the Zsh setup

`80-zsh-plugins.sh` does not edit `~/.zshrc` automatically. Follow [`docs/zsh-terminal.md`](./docs/zsh-terminal.md) to add the `ZSH_THEME` / `plugins=(...)` lines and to know exactly which other `~/.zshrc` snippets are safe to copy — and which env vars/tokens must NEVER be pasted into a script or commit.

### 5. Reload the shell

```sh
exec zsh
```

## 🔧 Manual installs (outside the Homebrew scope)

These tools are large/licensed and must be installed manually:

- **Android Studio** + Android SDK/NDK → https://developer.android.com/studio (adjust `ANDROID_HOME` and `JAVA_HOME` to the macOS paths).
- **Tizen Studio** → https://developer.tizen.org (with the CLI and emulators).
- **webOS TV SDK / Simulators** → https://webostv.developer.lge.com (the `ares-*` CLI goes into PATH; adjust it in `~/.zshrc`).
- **Samsung certificates** (`~/SamsungCertificate/`) → transfer over a secure channel.

## 🔁 Maintenance (updating the source of truth)

Regenerate the Brewfile from the current machine:

```sh
brew bundle dump --file=os/brew/Brewfile --force --describe
```

Regenerate the VS Code extensions list:

```sh
code --list-extensions > os/vscode/extensions.txt
```

## ✅ Principles

- **Idempotent:** every script checks before acting.
- **Agnostic:** detects OS/arch (`lib.sh`) and uses the correct Homebrew prefix.
- **Public-safe:** zero secrets and zero corporate certificates versioned.
- **Dry-run:** `--dry-run`/`-n` simulates the whole flow without running anything.
- **VS Code optional:** extensions via Settings Sync; script install is opt-in.
