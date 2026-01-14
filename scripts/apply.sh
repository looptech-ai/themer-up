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
YELLOW='\033[0;33m'
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
    echo -e "${YELLOW}○${NC} No iTerm2 config found"
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
    echo -e "${YELLOW}○${NC} No Powerlevel10k config found"
fi

# Apply mprocs config
if [ -f "$THEME_DIR/mprocs.yaml" ]; then
    mkdir -p "$HOME/.config/mprocs"
    cp "$THEME_DIR/mprocs.yaml" "$HOME/.config/mprocs/claude.yaml"
    echo -e "${GREEN}✓${NC} mprocs config applied"
else
    echo -e "${YELLOW}○${NC} No mprocs config found"
fi

# Apply VS Code settings
if [ -f "$THEME_DIR/vscode.json" ]; then
    VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
    if [ -f "$VSCODE_SETTINGS" ]; then
        # VS Code settings exist - recommend manual merge
        echo -e "${CYAN}ℹ${NC}  VS Code: Settings file exists"
        echo "     Run: code --install-extension RobbOwen.synthwave-vscode"
        echo "     Manual merge: $THEME_DIR/vscode.json"
    else
        # No VS Code settings - can copy directly
        mkdir -p "$(dirname "$VSCODE_SETTINGS")"
        cp "$THEME_DIR/vscode.json" "$VSCODE_SETTINGS"
        echo -e "${GREEN}✓${NC} VS Code settings applied"
    fi
else
    echo -e "${YELLOW}○${NC} No VS Code config found"
fi

# Apply Vim/Neovim colorscheme
if [ -f "$THEME_DIR/vim.vim" ]; then
    # Vim
    mkdir -p "$HOME/.vim/colors"
    cp "$THEME_DIR/vim.vim" "$HOME/.vim/colors/synthwave.vim"

    # Neovim
    mkdir -p "$HOME/.config/nvim/colors"
    cp "$THEME_DIR/vim.vim" "$HOME/.config/nvim/colors/synthwave.vim"

    # Add colorscheme to vimrc if not present
    if [ -f "$HOME/.vimrc" ]; then
        if ! grep -q "colorscheme synthwave" "$HOME/.vimrc"; then
            echo "" >> "$HOME/.vimrc"
            echo "\" Themer-up theme" >> "$HOME/.vimrc"
            echo "colorscheme synthwave" >> "$HOME/.vimrc"
        fi
    else
        echo "\" Themer-up theme" > "$HOME/.vimrc"
        echo "colorscheme synthwave" >> "$HOME/.vimrc"
    fi

    # Add to Neovim init.vim if it exists
    if [ -f "$HOME/.config/nvim/init.vim" ]; then
        if ! grep -q "colorscheme synthwave" "$HOME/.config/nvim/init.vim"; then
            echo "" >> "$HOME/.config/nvim/init.vim"
            echo "\" Themer-up theme" >> "$HOME/.config/nvim/init.vim"
            echo "colorscheme synthwave" >> "$HOME/.config/nvim/init.vim"
        fi
    fi

    # Add to Neovim init.lua if it exists
    if [ -f "$HOME/.config/nvim/init.lua" ]; then
        if ! grep -q "synthwave" "$HOME/.config/nvim/init.lua"; then
            echo "" >> "$HOME/.config/nvim/init.lua"
            echo "-- Themer-up theme" >> "$HOME/.config/nvim/init.lua"
            echo "vim.cmd('colorscheme synthwave')" >> "$HOME/.config/nvim/init.lua"
        fi
    fi

    echo -e "${GREEN}✓${NC} Vim/Neovim colorscheme applied"
else
    echo -e "${YELLOW}○${NC} No Vim config found"
fi

# Apply tmux config
if [ -f "$THEME_DIR/tmux.conf" ]; then
    # Check if tmux.conf exists
    if [ -f "$HOME/.tmux.conf" ]; then
        # Check if already sourcing themer-up
        if ! grep -q "themer-up" "$HOME/.tmux.conf"; then
            echo "" >> "$HOME/.tmux.conf"
            echo "# Themer-up theme" >> "$HOME/.tmux.conf"
            echo "source-file $THEME_DIR/tmux.conf" >> "$HOME/.tmux.conf"
        fi
    else
        echo "# Themer-up theme" > "$HOME/.tmux.conf"
        echo "source-file $THEME_DIR/tmux.conf" >> "$HOME/.tmux.conf"
    fi
    echo -e "${GREEN}✓${NC} tmux config applied"
    echo "     Reload with: tmux source-file ~/.tmux.conf"
else
    echo -e "${YELLOW}○${NC} No tmux config found"
fi

echo ""
echo -e "${GREEN}✨ Theme '$THEME_NAME' applied!${NC}"
echo ""
echo "Actions needed:"
echo "  • Restart iTerm2 to see terminal changes"
echo "  • Reload tmux: tmux source-file ~/.tmux.conf"
echo "  • Restart shell: source ~/.zshrc"
echo "  • Restart Vim/Neovim"
