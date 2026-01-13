#!/bin/bash
# Backup current theme configs before applying new theme

BACKUP_DIR="$HOME/.themer-up-backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Backing up to: $BACKUP_DIR"

# iTerm2
if [ -f "$HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json" ]; then
    cp "$HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json" \
       "$BACKUP_DIR/iterm2.json"
fi

# Powerlevel10k
if [ -f "$HOME/.p10k-themer.zsh" ]; then
    cp "$HOME/.p10k-themer.zsh" "$BACKUP_DIR/p10k.zsh"
fi

# mprocs
if [ -f "$HOME/.config/mprocs/claude.yaml" ]; then
    cp "$HOME/.config/mprocs/claude.yaml" "$BACKUP_DIR/mprocs.yaml"
fi

# Keep only last 5 backups
ls -dt "$HOME/.themer-up-backup"/*/ 2>/dev/null | tail -n +6 | xargs rm -rf 2>/dev/null || true

echo "Backup complete."
