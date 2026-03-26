#!/bin/sh

# echo-sync installer
# Supports macOS and Linux
#
# Usage (curl):
#   curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/echo-sync/main/install.sh | sh
#
# Usage (local):
#   sh install.sh


REPO_RAW="https://raw.githubusercontent.com/YOUR_USERNAME/echo-sync/main"
INSTALL_DIR="$HOME/bin"
SHELL_RC=""
OS="$(uname)"

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
DIM='\033[2m'
RESET='\033[0m'

# Detect which shell rc file to update
detect_shell_rc() {
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
}

# Install a package using whatever package manager is available
install_package() {
    pkg="$1"
    printf "${BOLD}Installing %s...${RESET}\n" "$pkg"

    if [ "$OS" = "Darwin" ]; then
        if command -v brew >/dev/null 2>&1; then
            brew install "$pkg"
        else
            printf "${YELLOW}⚠ Homebrew not found. Install it from https://brew.sh then run: brew install %s${RESET}\n" "$pkg"
            return 1
        fi
    else
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get install -y "$pkg"
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y "$pkg"
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -S --noconfirm "$pkg"
        elif command -v zypper >/dev/null 2>&1; then
            sudo zypper install -y "$pkg"
        else
            printf "${YELLOW}⚠ Could not detect a package manager. Please install %s manually.${RESET}\n" "$pkg"
            return 1
        fi
    fi
}

# ─── Prompt helpers ───────────────────────────────────────────────────────────

prompt_path() {
    label="$1"
    hint="$2"
    while true; do
        printf "  %s path: " "$label"
        read -r input_path < /dev/tty
        # Normalize: strip trailing slash then re-add
        input_path="${input_path%/}/"
        folder="${input_path%/}"
        if [ -d "$folder" ]; then
            printf "  ${GREEN}✓ Found: %s${RESET}\n" "$input_path"
            RESULT="$input_path"
            return 0
        else
            printf "  ${YELLOW}⚠ That path doesn't exist or isn't mounted right now.${RESET}\n"
            printf "  Use it anyway? [y/N]: "
            read -r confirm < /dev/tty
            case "$confirm" in
                [Yy]*) RESULT="$input_path"; return 0 ;;
            esac
        fi
    done
}

# ─── Start ────────────────────────────────────────────────────────────────────

printf "\n"
printf "${BOLD}╔══════════════════════════════╗${RESET}\n"
printf "${BOLD}║     echo-sync  installer     ║${RESET}\n"
printf "${BOLD}╚══════════════════════════════╝${RESET}\n"
printf "\n"

detect_shell_rc

# ─── Step 1: Source path ──────────────────────────────────────────────────────

printf "${BOLD}Source folder${RESET} — the folder to sync ${CYAN}from${RESET}\n"
if [ "$OS" = "Darwin" ]; then
    printf "${DIM}(e.g. /Volumes/DRIVE_NAME/Music)${RESET}\n"
else
    printf "${DIM}(e.g. /media/yourname/DRIVE_NAME/Music or /mnt/drive/Music)${RESET}\n"
fi
printf "\n"
prompt_path "Source"
SOURCE_PATH="$RESULT"
printf "\n"

# ─── Step 2: Destination path ─────────────────────────────────────────────────

printf "${BOLD}Destination folder${RESET} — the folder to sync ${CYAN}to${RESET}\n"
if [ "$OS" = "Darwin" ]; then
    printf "${DIM}(e.g. /Volumes/BACKUP_DRIVE)${RESET}\n"
else
    printf "${DIM}(e.g. /media/yourname/BACKUP_DRIVE or /mnt/backup)${RESET}\n"
fi
printf "\n"
prompt_path "Destination"
DEST_PATH="$RESULT"
printf "\n"

# ─── Confirm ──────────────────────────────────────────────────────────────────

printf "${DIM}──────────────────────────────────────────${RESET}\n\n"
printf "  Syncing:  ${CYAN}%s${RESET}\n" "$SOURCE_PATH"
printf "       →   ${CYAN}%s${RESET}\n" "$DEST_PATH"
printf "\n"
printf "  Looks good? [Y/n]: "
read -r confirm < /dev/tty
case "$confirm" in
    [Nn]*) printf "\n  Cancelled. Run the installer again to start over.\n\n"; exit 0 ;;
esac

printf "\n${DIM}──────────────────────────────────────────${RESET}\n\n"

# ─── Step 3: Create ~/bin ─────────────────────────────────────────────────────

if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
    printf "${GREEN}✓ Created %s${RESET}\n" "$INSTALL_DIR"
fi

# ─── Step 4: Download and configure echo-sync ────────────────────────────────

if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REPO_RAW/echo-sync" -o "$INSTALL_DIR/echo-sync"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "$INSTALL_DIR/echo-sync" "$REPO_RAW/echo-sync"
else
    printf "${RED}✗ Neither curl nor wget is available. Cannot download echo-sync.${RESET}\n"
    exit 1
fi

# Bake in source and dest paths (sed syntax differs between macOS and Linux)
if [ "$OS" = "Darwin" ]; then
    sed -i '' "s|##SOURCE_PATH##|$SOURCE_PATH|g" "$INSTALL_DIR/echo-sync"
    sed -i '' "s|##DEST_PATH##|$DEST_PATH|g"     "$INSTALL_DIR/echo-sync"
else
    sed -i "s|##SOURCE_PATH##|$SOURCE_PATH|g" "$INSTALL_DIR/echo-sync"
    sed -i "s|##DEST_PATH##|$DEST_PATH|g"     "$INSTALL_DIR/echo-sync"
fi

chmod +x "$INSTALL_DIR/echo-sync"
printf "${GREEN}✓ Installed echo-sync to %s${RESET}\n" "$INSTALL_DIR"

# ─── Step 5: Add ~/bin to PATH ────────────────────────────────────────────────

if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$SHELL_RC" 2>/dev/null; then
    printf '\n# echo-sync\nexport PATH="$HOME/bin:$PATH"\n' >> "$SHELL_RC"
    printf "${GREEN}✓ Added ~/bin to PATH in %s${RESET}\n" "$SHELL_RC"
else
    printf "${CYAN}✓ ~/bin already in PATH — skipped${RESET}\n"
fi

# ─── Step 6: Install watch dependency ────────────────────────────────────────

printf "\n${BOLD}Installing watch dependency...${RESET}\n\n"

if [ "$OS" = "Darwin" ]; then
    if command -v fswatch >/dev/null 2>&1; then
        printf "${CYAN}✓ fswatch already installed — skipped${RESET}\n"
    else
        install_package fswatch
    fi
else
    if command -v inotifywait >/dev/null 2>&1; then
        printf "${CYAN}✓ inotify-tools already installed — skipped${RESET}\n"
    else
        install_package inotify-tools
    fi
fi

# ─── Done ─────────────────────────────────────────────────────────────────────

printf "\n${DIM}──────────────────────────────────────────${RESET}\n\n"
printf "${GREEN}${BOLD}✓ Installation complete!${RESET}\n\n"
printf "  Open a new terminal window, then use:\n\n"
printf "    ${BOLD}echo-sync${RESET}          sync once\n"
printf "    ${BOLD}echo-sync --watch${RESET}  sync and watch for changes\n"
printf "    ${BOLD}echo-sync --help${RESET}   show usage\n\n"
