# Skill: Apply Theme

## Trigger
`/apply-theme [theme-name]`

## Description
Applies a theme from the themer-up library across all configured development tools.

## Steps

1. **Validate theme exists**
   ```bash
   ls ~/dev/themer-up/themes/{theme-name}/
   ```

2. **Backup current configs**
   ```bash
   ./scripts/backup.sh
   ```

3. **Apply iTerm2 profile**
   ```bash
   cp themes/{theme-name}/iterm2.json \
      ~/Library/Application\ Support/iTerm2/DynamicProfiles/themer-up.json
   ```

4. **Apply Powerlevel10k colors**
   ```bash
   cp themes/{theme-name}/p10k.zsh ~/.p10k-themer.zsh
   # Ensure .zshrc sources it
   ```

5. **Apply VS Code settings**
   ```bash
   # Merge theme colors into VS Code settings
   ```

6. **Apply mprocs config**
   ```bash
   cp themes/{theme-name}/mprocs.yaml ~/.config/mprocs/claude.yaml
   ```

7. **Verify application**
   - Check each config file exists
   - Report success/failure for each tool

## Example Usage
```
User: /apply-theme synthwave
Agent: Applying synthwave theme...
       ✓ iTerm2 profile applied
       ✓ Powerlevel10k colors applied
       ✓ VS Code settings updated
       ✓ mprocs config applied

       Theme 'synthwave' is now active.
       Restart iTerm2 to see terminal changes.
```

## Rollback
If something goes wrong:
```bash
./scripts/restore.sh
```
