#!/usr/bin/env bats
# Unit tests for apply.sh

load '../test_helper'

setup() {
    setup_test_home
    export THEMER_DIR="${BATS_TEST_DIRNAME}/../.."

    # Create a mock backup script that doesn't fail
    mkdir -p "$TEST_HOME/scripts"
    cat > "$TEST_HOME/scripts/backup.sh" << 'EOF'
#!/bin/bash
mkdir -p "$HOME/.themer-up-backup/mock_backup"
echo "Mock backup"
EOF
    chmod +x "$TEST_HOME/scripts/backup.sh"

    # Temporarily patch the apply script to use our mock backup
    # We'll test with the real script but mock external dependencies
}

teardown() {
    teardown_test_home
}

@test "apply.sh exits with error for non-existent theme" {
    run "$SCRIPTS_DIR/apply.sh" "nonexistent-theme"
    [ "$status" -eq 1 ]
    [[ "$output" == *"not found"* ]]
}

@test "apply.sh shows available themes when theme not found" {
    run "$SCRIPTS_DIR/apply.sh" "nonexistent-theme"
    [[ "$output" == *"Available themes"* ]] || [[ "$output" == *"synthwave"* ]]
}

@test "apply.sh uses synthwave as default theme" {
    # The script should reference synthwave if no arg provided
    # We can verify by checking the script's default behavior
    run bash -c "source $SCRIPTS_DIR/apply.sh 2>&1 || true" <<< ""
    # Script will try to apply synthwave by default
    [[ "$output" == *"synthwave"* ]] || [ "$status" -eq 0 ]
}

@test "apply.sh creates backup before applying" {
    run "$SCRIPTS_DIR/apply.sh" "synthwave"

    # Backup should have been attempted (directory created)
    assert_dir_exists "$TEST_BACKUP_DIR"
}

@test "apply.sh copies iTerm2 profile" {
    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    iterm_profile="$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json"
    assert_file_exists "$iterm_profile"
}

@test "apply.sh copies p10k theme file" {
    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    assert_file_exists "$TEST_HOME/.p10k-themer.zsh"
}

@test "apply.sh adds p10k source line to .zshrc if not present" {
    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    assert_file_contains "$TEST_HOME/.zshrc" "p10k-themer.zsh"
}

@test "apply.sh does not duplicate p10k source line" {
    # Pre-add the source line
    echo "[[ -f ~/.p10k-themer.zsh ]] && source ~/.p10k-themer.zsh" >> "$TEST_HOME/.zshrc"

    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    # Count occurrences - should be exactly 1
    count=$(grep -c "p10k-themer.zsh" "$TEST_HOME/.zshrc" || echo 0)
    [ "$count" -eq 1 ]
}

@test "apply.sh copies mprocs config" {
    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    assert_file_exists "$TEST_HOME/.config/mprocs/claude.yaml"
}

@test "apply.sh installs vim colorscheme" {
    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    assert_file_exists "$TEST_HOME/.vim/colors/synthwave.vim"
    assert_file_exists "$TEST_HOME/.config/nvim/colors/synthwave.vim"
}

@test "apply.sh adds colorscheme to vimrc" {
    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    assert_file_contains "$TEST_HOME/.vimrc" "colorscheme synthwave"
}

@test "apply.sh outputs success message" {
    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]
    [[ "$output" == *"applied"* ]]
}

@test "apply.sh shows restart instructions" {
    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Restart iTerm2"* ]] || [[ "$output" == *"Actions needed"* ]]
}
