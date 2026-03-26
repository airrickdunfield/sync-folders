# echo-sync

A terminal tool for syncing a source folder to a destination folder — with optional file watching that automatically re-syncs whenever something changes.

Supports **macOS** and **Linux**.

---

## Installation

```sh
curl -fsSL https://raw.githubusercontent.com/airrickdunfield/sync-folders/main/install.sh | sh
```

The installer will:

1. Ask for your **source folder** (the folder to sync from)
2. Ask for your **destination folder** (the folder to sync to)
3. Download `echo-sync`, bake your paths into it, and install it to `~/bin/`
4. Add `~/bin` to your `PATH` in your shell config (`.zshrc`, `.bashrc`, or `.bash_profile`)
5. Install the watch dependency automatically — `fswatch` on macOS via Homebrew, `inotify-tools` on Linux via your distro's package manager

Open a new terminal window after installing for the changes to take effect.

---

## Usage

```sh
echo-sync             # Sync once and exit
echo-sync --watch     # Sync now, then watch for changes and re-sync automatically
echo-sync --help      # Show usage and configured paths
```

**How sync works:** files are mirrored from source to destination using `rsync`. If a file is deleted from the source, it will also be deleted from the destination — keeping both folders identical.

---

## Uninstallation

```sh
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/echo-sync/main/uninstall.sh | sh
```

This removes the `echo-sync` script from `~/bin/` and cleans up the `PATH` entry in your shell config. Open a new terminal window after running it.

---

## Requirements

| | macOS | Linux |
|---|---|---|
| Shell | zsh or bash | zsh or bash |
| Sync | `rsync` (included) | `rsync` (usually included) |
| Watch mode | `fswatch` (auto-installed via Homebrew) | `inotify-tools` (auto-installed via apt/dnf/pacman/zypper) |
| curl install | Homebrew required | Not required |

---

## Files

| File | Description |
|---|---|
| `echo-sync` | The main sync script |
| `install.sh` | Installs echo-sync on your machine |
| `uninstall.sh` | Removes echo-sync from your machine |
