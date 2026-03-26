#!/bin/sh

# echo-sync uninstaller
# Supports macOS and Linux
#
# Usage:
#   sh uninstall.sh

INSTALL_DIR="$HOME/bin"
OS="$(uname)"

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'
DIM='\033[2m'

# Detect shell rc file
if [ -n "$ZSH_VERSION" ] || [ "$(basename "$SHELL")" = "zsh" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ] || [ "$(basename "$SHELL")" = "bash" ]; then
    if [ "$OS" = "Darwin" ]; then
        SHELL_RC="$HOME/.bash_profile"
    else
        SHELL_RC="$HOME/.bashrc"
    fi
else
    SHELL_RC="$HOME/.profile"
fi

printf "\n${BOLD}Uninstalling echo-sync...${RESET}\n\n"

# ─── Remove the script ────────────────────────────────────────────────────────

if [ -f "$INSTALL_DIR/echo-sync" ]; then
    rm "$INSTALL_DIR/echo-sync"
    printf "${GREEN}✓ Removed %s/echo-sync${RESET}\n" "$INSTALL_DIR"
else
    printf "${YELLOW}⚠ echo-sync not found in %s — skipping${RESET}\n" "$INSTALL_DIR"
fi

# ─── Remove the PATH entry from shell rc ─────────────────────────────────────

if grep -q '# echo-sync' "$SHELL_RC" 2>/dev/null; then
    if [ "$OS" = "Darwin" ]; then
        sed -i '' '/# echo-sync/{N;N;d;}' "$SHELL_RC"
    else
        sed -i '/# echo-sync/{N;N;d;}' "$SHELL_RC"
    fi
    printf "${GREEN}✓ Removed PATH entry from %s${RESET}\n" "$SHELL_RC"
else
    printf "${YELLOW}⚠ No echo-sync entry found in %s — skipping${RESET}\n" "$SHELL_RC"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────

printf "\n${GREEN}${BOLD}✓ echo-sync uninstalled.${RESET}\n"
printf "${DIM}Open a new terminal window for the PATH change to take effect.${RESET}\n\n"
