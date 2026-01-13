# Themer Up - Development Environment Theming Agent

## Purpose

Themer Up is a **self-aware theming agent** that manages consistent visual themes across your entire development environment. It provides deterministic theme application while being intelligent enough to create and evolve new themes.

---

## Core Capabilities

### 1. Theme Orchestration
Apply themes consistently across all tools:
- **iTerm2** - Terminal profiles with colors, fonts, backgrounds
- **Powerlevel10k** - Zsh prompt theming
- **VS Code** - Editor themes and terminal colors
- **mprocs** - Multi-process terminal configs
- **Vim/Neovim** - Editor colorschemes
- **tmux** - Terminal multiplexer themes

### 2. Theme Creation
The agent can create new themes by:
- Generating color palettes from base colors
- Deriving complementary/analogous colors
- Applying consistent naming conventions
- Creating all tool-specific config files

### 3. Theme Application
Deterministic walkthrough for applying themes:
1. Backup current configs
2. Apply iTerm2 profile
3. Apply Powerlevel10k colors
4. Apply VS Code settings
5. Apply mprocs config
6. Verify all tools are themed

---

## Project Structure

```
themer-up/
├── .claude/
│   ├── CLAUDE.md           # This file
│   └── settings.local.json # Local Claude settings
├── themes/
│   ├── synthwave/          # Synthwave purple theme
│   │   ├── iterm2.json
│   │   ├── p10k.zsh
│   │   ├── vscode.json
│   │   └── mprocs.yaml
│   ├── dracula/            # Dracula theme (example)
│   ├── nord/               # Nord theme (example)
│   └── custom/             # User-created themes
├── skills/
│   ├── apply-theme.md      # Skill for applying themes
│   ├── create-theme.md     # Skill for creating themes
│   └── list-themes.md      # Skill for listing themes
├── scripts/
│   ├── apply.sh            # Shell script for applying themes
│   ├── backup.sh           # Backup current configs
│   └── install.sh          # Install themer-up
└── README.md
```

---

## Theme Schema

Each theme follows this structure:

```typescript
interface Theme {
  name: string;
  description: string;
  colors: {
    // Core palette
    background: string;      // Main background
    foreground: string;      // Main text
    cursor: string;          // Cursor color
    selection: string;       // Selection background

    // ANSI colors (0-15)
    black: string;
    red: string;
    green: string;
    yellow: string;
    blue: string;
    magenta: string;
    cyan: string;
    white: string;
    brightBlack: string;
    brightRed: string;
    brightGreen: string;
    brightYellow: string;
    brightBlue: string;
    brightMagenta: string;
    brightCyan: string;
    brightWhite: string;

    // Accent colors
    accent1: string;         // Primary accent
    accent2: string;         // Secondary accent
    accent3: string;         // Tertiary accent
  };

  fonts: {
    terminal: string;        // Terminal font
    editor: string;          // Editor font
    size: number;            // Base font size
  };
}
```

---

## Bundled Themes

### Synthwave (Default)
A dark purple/pink/cyan theme inspired by 80s retrowave aesthetics.

| Element | Color |
|---------|-------|
| Background | `#1a1a2e` |
| Foreground | `#eaeaea` |
| Accent 1 (Pink) | `#ff79c6` |
| Accent 2 (Cyan) | `#8be9fd` |
| Accent 3 (Purple) | `#bd93f9` |

### Creating New Themes

To create a new theme, the agent needs:
1. **Name** - Unique identifier (lowercase, no spaces)
2. **Base colors** - At minimum: background, foreground, 3 accents
3. **Description** - What inspired/defines this theme

The agent will then:
- Generate full ANSI color palette
- Create all tool-specific configs
- Add to themes directory
- Update theme registry

---

## Skills Reference

### /apply-theme [name]
Apply a theme across all tools.

```bash
# Usage
claude "/apply-theme synthwave"
```

### /create-theme [name] [colors]
Create a new theme from base colors.

```bash
# Usage
claude "/create-theme cyberpunk --bg=#0d0d0d --fg=#00ff00 --accent=#ff0000"
```

### /list-themes
List all available themes.

### /preview-theme [name]
Show theme colors without applying.

---

## Installation Paths

The agent manages configs at these locations:

| Tool | Config Path |
|------|-------------|
| iTerm2 | `~/Library/Application Support/iTerm2/DynamicProfiles/` |
| Powerlevel10k | `~/.p10k-{theme}.zsh` |
| VS Code | `~/Library/Application Support/Code/User/settings.json` |
| mprocs | `~/.config/mprocs/` |
| Vim | `~/.vimrc` or `~/.config/nvim/` |
| tmux | `~/.tmux.conf` |

---

## Safety

Before applying any theme:
1. **Backup** - All existing configs are backed up to `~/.themer-up-backup/`
2. **Verify** - Check that target paths exist
3. **Rollback** - Keep previous theme for instant rollback

---

## Development Commands

```bash
# Navigate to project
cd ~/dev/themer-up

# Apply current theme
./scripts/apply.sh synthwave

# Create backup
./scripts/backup.sh

# List themes
ls themes/
```
