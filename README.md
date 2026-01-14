# 🎨 Themer Up

A self-aware development environment theming agent for consistent visual themes across all your tools.

## Features

- **Unified Theming** - Apply themes across iTerm2, Powerlevel10k, VS Code, mprocs, and more
- **Theme Creation** - Generate complete color palettes from base colors
- **Claude Integration** - Skills for AI-assisted theme management
- **Deterministic Application** - Reliable, repeatable theme switching
- **Auto-Backup** - Never lose your configs

## Quick Start

```bash
# Apply the default synthwave theme
./scripts/apply.sh synthwave

# Or use Claude skills
claude "/apply-theme synthwave"
```

## Available Themes

| Theme | Description |
|-------|-------------|
| `synthwave` | 80s retrowave purple/pink/cyan |

## Creating Themes

Use the `/create-theme` skill:

```bash
claude "/create-theme cyberpunk --bg=#0a0a0a --fg=#00ff41 --accent=#ff0055"
```

Or manually create a theme directory:

```
themes/my-theme/
├── iterm2.json      # iTerm2 dynamic profile
├── p10k.zsh         # Powerlevel10k colors
├── vscode.json      # VS Code terminal colors
├── mprocs.yaml      # mprocs config
└── theme.json       # Theme metadata
```

## Claude Skills

| Skill | Description |
|-------|-------------|
| `/apply-theme [name]` | Apply a theme to all tools |
| `/create-theme [name] --colors` | Generate a new theme |
| `/list-themes` | Show available themes |

## Installation

```bash
# Clone the repo
git clone https://github.com/looptech-ai/themer-up.git ~/dev/themer-up

# Apply default theme
cd ~/dev/themer-up
./scripts/apply.sh
```

## Supported Tools

- [x] iTerm2 (Dynamic Profiles)
- [x] Powerlevel10k (Color overrides)
- [x] mprocs (Multi-process configs)
- [x] VS Code (Terminal + editor colors)
- [x] Vim/Neovim (Full colorscheme with TreeSitter support)
- [x] tmux (Status bar + pane styling)

## Project Structure

```
themer-up/
├── .claude/           # Claude project config
├── themes/            # Theme definitions
│   └── synthwave/     # Default theme
├── skills/            # Claude skills
├── scripts/           # Shell utilities
└── README.md
```

## License

MIT
