# envctl

[![CI](https://github.com/Capacium/envctl/actions/workflows/ci.yml/badge.svg)](https://github.com/Capacium/envctl/actions/workflows/ci.yml)
[![CodeQL](https://github.com/Capacium/envctl/actions/workflows/codeql.yml/badge.svg)](https://github.com/Capacium/envctl/actions/workflows/codeql.yml)
[![Release](https://img.shields.io/github/v/release/Capacium/envctl?display_name=tag)](https://github.com/Capacium/envctl/releases)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](./LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash-green.svg)](./bin/envctl)
[![macOS](https://img.shields.io/badge/macOS-✓-brightgreen.svg)](#)
[![Linux](https://img.shields.io/badge/Linux-✓-brightgreen.svg)](#)

> One place for all your API keys and tokens — available everywhere, even in GUI apps.

**envctl** solves the gap between `.env` files and running applications: secrets defined once in `~/.config/envctl/` are injected into every process at login — Claude Desktop, Codex, CodeNomad, VS Code, any app launched from Dock or Spotlight — without touching each app's config individually.

---

## Installation

### Homebrew (recommended)

```bash
brew tap Capacium/tap
brew install envctl
```

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/Capacium/envctl/main/install.sh | bash
```

### Manual

```bash
curl -fsSL https://raw.githubusercontent.com/Capacium/envctl/main/bin/envctl \
  -o /usr/local/bin/envctl && chmod +x /usr/local/bin/envctl
```

---

## Quickstart

```bash
# 1. Add your first key to a named cluster
envctl set ai V0_API_KEY=your-key-here
envctl set ai OPENAI_API_KEY=sk-...

# 2. Install the system integration (once)
envctl install

# 3. Reload — active immediately in all new processes
envctl reload

# 4. Check what's loaded
envctl list
envctl status
```

---

## Key Management

Managing keys is as simple as using `export` — but persistent and available everywhere:

```bash
# Add or update
envctl set ai     V0_API_KEY=abc123
envctl set cloud  AWS_ACCESS_KEY_ID=AKIA...
envctl set dev    GITHUB_TOKEN=ghp_...

# Read a value
envctl get ai V0_API_KEY

# Remove a key
envctl rm ai OLD_KEY

# Edit a cluster file directly
envctl edit ai
```

---

## Clusters

Keys are organized into **cluster files** — one `.env` file per logical group:

```
~/.config/envctl/
  ai.env        # AI service keys (v0, OpenAI, Anthropic, Gemini…)
  cloud.env     # Cloud providers (AWS, GCP, Cloudflare…)
  dev.env       # Developer tokens (GitHub, npm, Vercel…)
```

You can have as many clusters as you need. Each is a standard `.env` file — plain `KEY=VALUE`, comments with `#`. See [`examples/`](./examples/) for templates.

```bash
# Load only one cluster
envctl load ai

# List all clusters (values masked)
envctl list

# Load a specific cluster
envctl list cloud

# Check active status per cluster
envctl status
```

---

## How It Works

### macOS — LaunchAgent

`envctl install` writes a LaunchAgent plist to `~/Library/LaunchAgents/com.user.envctl.plist`. At login, it runs a loader script that calls `launchctl setenv KEY VALUE` for every key in every cluster. This makes the variables available to **all user processes** — including GUI apps launched from Dock, Spotlight, or any launcher.

```
Login
  └─ LaunchAgent (com.user.envctl)
       └─ loader.sh
            ├─ launchctl setenv V0_API_KEY ...
            ├─ launchctl setenv OPENAI_API_KEY ...
            └─ ...
                 └─ Available to: Claude Desktop, Codex, CodeNomad, VS Code, ...
```

After adding or changing keys, run `envctl reload` — no logout required for CLI sessions. For GUI apps, a restart of the app is sufficient (no logout needed after the initial install).

### Linux — environment.d

`envctl install` copies cluster files into `~/.config/environment.d/` which `systemd --user` reads at session start, making vars available to all user processes including Wayland and X11 GUI apps.

---

## Shell Integration

For terminal sessions, add to `~/.zshrc` or `~/.bashrc`:

```bash
# Source all envctl clusters in new shell sessions
for f in ~/.config/envctl/*.env; do
  [ -f "$f" ] && set -a && source "$f" && set +a
done
```

Or use `envctl load` in your profile to do this via the CLI.

---

## Commands

| Command | Description |
|---|---|
| `envctl set <cluster> KEY=VALUE` | Add or update a variable |
| `envctl rm <cluster> KEY` | Remove a variable |
| `envctl get <cluster> KEY` | Print raw value |
| `envctl list [cluster]` | List vars (masked) |
| `envctl status [cluster]` | Show active system state |
| `envctl load [cluster]` | Load into current session |
| `envctl reload` | Reload all clusters |
| `envctl edit [cluster]` | Open cluster in `$EDITOR` |
| `envctl install` | Install LaunchAgent / environment.d |
| `envctl uninstall` | Remove LaunchAgent / environment.d |

---

## Comparison

| | envctl | export in .zshrc | direnv | per-app config |
|---|---|---|---|---|
| GUI apps (Dock/Spotlight) | ✓ | ✗ | ✗ | manual each |
| CLI apps | ✓ | ✓ | project-scoped | manual each |
| Clustered / organized | ✓ | ✗ | ✗ | n/a |
| Single source of truth | ✓ | partial | partial | ✗ |
| No daemon required | ✓ | ✓ | ✓ | ✓ |
| macOS LaunchAgent | ✓ | ✗ | ✗ | ✗ |
| Linux environment.d | ✓ | ✗ | ✗ | ✗ |

---

## Security

- Cluster files are plain text — set permissions: `chmod 600 ~/.config/envctl/*.env`
- Never commit `~/.config/envctl/` to git — add it to your global `.gitignore`
- See [SECURITY.md](./SECURITY.md) for reporting vulnerabilities

---

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

---

## License

Apache-2.0 — see [LICENSE](./LICENSE)
