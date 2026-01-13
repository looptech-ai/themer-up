#!/bin/bash
# Apply a themer-up theme across all development tools

set -e

THEMER_DIR="$HOME/dev/themer-up"
THEME_NAME="${1:-synthwave}"
THEME_DIR="$THEMER_DIR/themes/$THEME_NAME"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}🎨 Applying theme: $THEME_NAME${NC}"
echo ""

# Check theme exists
if [ ! -d "$THEME_DIR" ]; then
    echo -e "${RED}✗ Theme '$THEME_NAME' not found${NC}"
    echo "  Available themes:"
    ls "$THEMER_DIR/themes/"
    exit 1
fi

# Backup first
echo "📦 Creating backup..."
"$THEMER_DIR/scripts/backup.sh"

# Apply iTerm2 profile
if [ -f "$THEME_DIR/iterm2.json" ]; then
    cp "$THEME_DIR/iterm2.json" \
       "$HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json"
    echo -e "${GREEN}✓${NC} iTerm2 profile applied"
else
    echo -e "${RED}✗${NC} No iTerm2 config found"
fi

# Apply Powerlevel10k theme
if [ -f "$THEME_DIR/p10k.zsh" ]; then
    cp "$THEME_DIR/p10k.zsh" "$HOME/.p10k-themer.zsh"
    # Check if sourced in .zshrc
    if ! grep -q "p10k-themer.zsh" "$HOME/.zshrc"; then
        echo "" >> "$HOME/.zshrc"
        echo "# Themer-up Powerlevel10k colors" >> "$HOME/.zshrc"
        echo "[[ -f ~/.p10k-themer.zsh ]] && source ~/.p10k-themer.zsh" >> "$HOME/.zshrc"
    fi
    echo -e "${GREEN}✓${NC} Powerlevel10k colors applied"
else
    echo -e "${RED}✗${NC} No Powerlevel10k config found"
fi

# Apply mprocs config
if [ -f "$THEME_DIR/mprocs.yaml" ]; then
    mkdir -p "$HOME/.config/mprocs"
    cp "$THEME_DIR/mprocs.yaml" "$HOME/.config/mprocs/claude.yaml"
    echo -e "${GREEN}✓${NC} mprocs config applied"
else
    echo -e "${RED}✗${NC} No mprocs config found"
fi

# Apply VS Code settings (merge, don't overwrite)
if [ -f "$THEME_DIR/vscode.json" ]; then
    echo -e "${CYAN}ℹ${NC}  VS Code: Manual merge recommended"
    echo "     See: $THEME_DIR/vscode.json"
fi

echo ""
echo -e "${GREEN}✨ Theme '$THEME_NAME' applied!${NC}"
echo ""
echo "Restart iTerm2 to see terminal changes."
