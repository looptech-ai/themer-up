# Skill: List Themes

## Trigger
`/list-themes` or `/themes`

## Description
Lists all available themes in the themer-up library with preview information.

## Steps

1. **Scan themes directory**
   ```bash
   ls ~/dev/themer-up/themes/
   ```

2. **Read theme metadata**
   - Parse `theme.json` from each theme directory
   - Extract name, description, and color preview

3. **Format output**
   - Display as table with color swatches (if terminal supports)
   - Show which theme is currently active

## Example Output
```
Available Themes:
─────────────────────────────────────────────────────────
  NAME        DESCRIPTION                    COLORS
─────────────────────────────────────────────────────────
★ synthwave   80s retrowave purple/pink      ██ ██ ██
  dracula     Dark theme with purple accents ██ ██ ██
  nord        Arctic, north-bluish palette   ██ ██ ██
  cyberpunk   Neon green matrix style        ██ ██ ██
─────────────────────────────────────────────────────────
★ = currently active

Use '/apply-theme [name]' to switch themes.
Use '/create-theme [name] --bg=... --fg=... --accent=...' to create new.
```

## Detailed View
`/list-themes --detailed` shows full color palette for each theme.
