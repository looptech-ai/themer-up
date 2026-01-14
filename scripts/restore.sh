#!/bin/bash
# Restore from the most recent backup

# Support custom backup location via environment variable
BACKUP_BASE="${THEMER_BACKUP_DIR:-$HOME/.themer-up-backup}"
BACKUP_DIR=$(ls -dt "${BACKUP_BASE}"/*/ 2>/dev/null | head -1)

if [ -z "$BACKUP_DIR" ]; then
    echo "No backups found."
    exit 1
fi

echo "Restoring from: $BACKUP_DIR"

# iTerm2
if [ -f "$BACKUP_DIR/iterm2.json" ]; then
    cp "$BACKUP_DIR/iterm2.json" \
       "$HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json"
    echo "✓ iTerm2 restored"
fi

# Powerlevel10k
if [ -f "$BACKUP_DIR/p10k.zsh" ]; then
    cp "$BACKUP_DIR/p10k.zsh" "$HOME/.p10k-themer.zsh"
    echo "✓ Powerlevel10k restored"
fi

# mprocs
if [ -f "$BACKUP_DIR/mprocs.yaml" ]; then
    cp "$BACKUP_DIR/mprocs.yaml" "$HOME/.config/mprocs/claude.yaml"
    echo "✓ mprocs restored"
fi

echo ""
echo "Restore complete. Restart iTerm2 to see changes."
