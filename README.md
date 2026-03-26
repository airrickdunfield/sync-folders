# folder-sync

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
3. Download `folder-sync`, bake your paths into it, and install it to `~/bin/`
4. Add `~/bin` to your `PATH` in your shell config (`.zshrc`, `.bashrc`, or `.bash_profile`)
5. Install the watch dependency automatically — `fswatch` on macOS via Homebrew, `inotify-tools` on Linux via your distro's package manager

Open a new terminal window after installing for the changes to take effect.

---

## Usage

```sh
folder-sync             # Sync once and exit
folder-sync --watch     # Sync now, then watch for changes and re-sync automatically
folder-sync --help      # Show usage and configured paths
```

**How sync works:** files are mirrored from source to destination using `rsync`. If a file is deleted from the source, it will also be deleted from the destination — keeping both folders identical.

---

## Uninstallation

```sh
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/folder-sync/main/uninstall.sh | sh
```

This removes the `folder-sync` script from `~/bin/` and cleans up the `PATH` entry in your shell config. Open a new terminal window after running it.

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
| `folder-sync` | The main sync script |
| `install.sh` | Installs folder-sync on your machine |
| `uninstall.sh` | Removes folder-sync from your machine |
