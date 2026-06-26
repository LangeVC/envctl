#!/usr/bin/env bash
set -euo pipefail

# envctl installer — https://github.com/LangeVC/envctl
ENVCTL_VERSION="${ENVCTL_VERSION:-0.1.0}"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
REPO="LangeVC/envctl"

_bold()  { printf '\033[1m%s\033[0m' "$*"; }
_green() { printf '\033[32m%s\033[0m' "$*"; }
_red()   { printf '\033[31m%s\033[0m' "$*"; }

echo ""
echo "$(_bold "envctl installer")"
echo "─────────────────────────────────────"

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Darwin) PLATFORM="macos" ;;
  Linux)  PLATFORM="linux" ;;
  *) echo "$(_red "✗") Unsupported OS: $OS" >&2; exit 1 ;;
esac
echo "  Platform : $PLATFORM"

# Detect install dir
if [[ ! -w "$INSTALL_DIR" ]]; then
  INSTALL_DIR="$HOME/.local/bin"
  mkdir -p "$INSTALL_DIR"
fi
echo "  Install  : $INSTALL_DIR/envctl"

# Download
TMP="$(mktemp)"
URL="https://raw.githubusercontent.com/${REPO}/v${ENVCTL_VERSION}/bin/envctl"
echo "  Source   : $URL"
echo ""

if command -v curl &>/dev/null; then
  curl -fsSL "$URL" -o "$TMP"
elif command -v wget &>/dev/null; then
  wget -qO "$TMP" "$URL"
else
  echo "$(_red "✗") curl or wget required" >&2
  exit 1
fi

chmod +x "$TMP"
mv "$TMP" "$INSTALL_DIR/envctl"

echo "$(_green "✓") envctl $ENVCTL_VERSION installed to $INSTALL_DIR/envctl"
echo ""

# PATH check
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
  echo "  $(_bold "→ Add to your shell profile:")"
  echo "    export PATH=\"\$PATH:$INSTALL_DIR\""
  echo ""
fi

echo "  $(_bold "Next steps:")"
echo "    envctl set ai V0_API_KEY=your-key"
echo "    envctl install    # set up LaunchAgent / environment.d"
echo "    envctl reload"
echo ""
