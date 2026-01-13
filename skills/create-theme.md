# Skill: Create Theme

## Trigger
`/create-theme [name] --bg=[color] --fg=[color] --accent=[color]`

## Description
Creates a new theme by generating a complete color palette from base colors.

## Required Inputs
- `name` - Theme identifier (lowercase, alphanumeric, hyphens)
- `--bg` - Background color (hex)
- `--fg` - Foreground color (hex)
- `--accent` - Primary accent color (hex)

## Optional Inputs
- `--accent2` - Secondary accent (auto-generated if not provided)
- `--accent3` - Tertiary accent (auto-generated if not provided)
- `--description` - Theme description

## Color Generation Algorithm

When only base colors are provided, the agent generates:

1. **ANSI Colors** - Derived from accent colors with varying luminosity
2. **Selection color** - Accent at 30% opacity over background
3. **Cursor color** - Primary accent
4. **Bright variants** - +20% luminosity of base ANSI colors

## Steps

1. **Validate inputs**
   - Check name is unique
   - Validate hex colors

2. **Generate color palette**
   ```javascript
   // Pseudo-code for color generation
   const palette = {
     black: darken(bg, 10),
     red: shiftHue(accent, 0),
     green: shiftHue(accent, 120),
     yellow: shiftHue(accent, 60),
     blue: shiftHue(accent, 240),
     magenta: shiftHue(accent, 300),
     cyan: shiftHue(accent, 180),
     white: fg,
     // Bright variants...
   };
   ```

3. **Create theme directory**
   ```bash
   mkdir -p ~/dev/themer-up/themes/{name}/
   ```

4. **Generate config files**
   - `iterm2.json` - iTerm2 dynamic profile
   - `p10k.zsh` - Powerlevel10k color overrides
   - `vscode.json` - VS Code terminal colors
   - `mprocs.yaml` - mprocs config with theme name
   - `theme.json` - Theme metadata

5. **Register theme**
   - Add to themes index
   - Update README

## Example Usage
```
User: /create-theme cyberpunk --bg=#0a0a0a --fg=#00ff41 --accent=#ff0055
Agent: Creating theme 'cyberpunk'...

       Generated palette:
       ├── Background: #0a0a0a
       ├── Foreground: #00ff41
       ├── Accent 1: #ff0055 (provided)
       ├── Accent 2: #00ffff (generated - cyan complement)
       ├── Accent 3: #ffff00 (generated - yellow complement)

       Created files:
       ├── themes/cyberpunk/iterm2.json
       ├── themes/cyberpunk/p10k.zsh
       ├── themes/cyberpunk/vscode.json
       ├── themes/cyberpunk/mprocs.yaml
       └── themes/cyberpunk/theme.json

       Theme 'cyberpunk' is ready!
       Run '/apply-theme cyberpunk' to use it.
```

## Theme Metadata (theme.json)
```json
{
  "name": "cyberpunk",
  "description": "Neon green on black with hot pink accents",
  "author": "themer-up",
  "created": "2025-01-13",
  "colors": {
    "background": "#0a0a0a",
    "foreground": "#00ff41",
    "accent1": "#ff0055",
    "accent2": "#00ffff",
    "accent3": "#ffff00"
  }
}
```
