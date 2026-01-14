#!/usr/bin/env bats
# Integration tests for complete theme application workflow

load '../test_helper'

setup() {
    setup_test_home
    export THEMER_DIR="${BATS_TEST_DIRNAME}/../.."

    # Create realistic initial state
    echo '{"Name": "Default", "Guid": "default-profile"}' > "$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json"
    echo "# Original zshrc content" > "$TEST_HOME/.zshrc"
    echo '" Original vimrc' > "$TEST_HOME/.vimrc"
}

teardown() {
    teardown_test_home
}

# --- Full Workflow Tests ---

@test "workflow: apply -> backup -> apply different -> restore returns to first" {
    # Step 1: Apply synthwave
    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    # Capture what was applied
    original_iterm=$(cat "$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json")

    # Step 2: Manually modify to simulate "different theme state"
    echo '{"modified": true}' > "$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json"

    # Step 3: Backup current state
    run "$SCRIPTS_DIR/backup.sh"
    [ "$status" -eq 0 ]

    # Step 4: Apply synthwave again (simulating re-apply)
    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    # Step 5: Restore should bring back the modified state
    run "$SCRIPTS_DIR/restore.sh"
    [ "$status" -eq 0 ]

    restored=$(cat "$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json")
    [[ "$restored" == *"modified"* ]]
}

@test "workflow: multiple applies don't duplicate zshrc entries" {
    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    # Should only have one source line for p10k-themer
    count=$(grep -c "p10k-themer.zsh" "$TEST_HOME/.zshrc" || echo 0)
    [ "$count" -eq 1 ]
}

@test "workflow: backup rotation preserves recent backups" {
    # Create initial state and apply
    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    # Run backup multiple times
    for i in {1..7}; do
        sleep 0.2  # Ensure unique timestamps
        run "$SCRIPTS_DIR/backup.sh"
        [ "$status" -eq 0 ]
    done

    # Should have at most 5 backups
    backup_count=$(find "$TEST_BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
    [ "$backup_count" -le 5 ]
}

# --- Theme Validation Tests ---

@test "theme: synthwave contains all required config files" {
    theme_dir="${THEMER_DIR}/themes/synthwave"

    assert_file_exists "${theme_dir}/iterm2.json"
    assert_file_exists "${theme_dir}/p10k.zsh"
    assert_file_exists "${theme_dir}/mprocs.yaml"
    assert_file_exists "${theme_dir}/vscode.json"
    assert_file_exists "${theme_dir}/theme.json"
    assert_file_exists "${theme_dir}/vim.vim"
    assert_file_exists "${theme_dir}/tmux.conf"
}

@test "theme: iterm2.json is valid JSON" {
    theme_dir="${THEMER_DIR}/themes/synthwave"

    run cat "${theme_dir}/iterm2.json"
    [ "$status" -eq 0 ]

    # Validate JSON
    run bash -c "cat '${theme_dir}/iterm2.json' | python3 -m json.tool > /dev/null 2>&1"
    [ "$status" -eq 0 ]
}

@test "theme: vscode.json is valid JSON" {
    theme_dir="${THEMER_DIR}/themes/synthwave"

    run bash -c "cat '${theme_dir}/vscode.json' | python3 -m json.tool > /dev/null 2>&1"
    [ "$status" -eq 0 ]
}

@test "theme: theme.json contains required color definitions" {
    theme_dir="${THEMER_DIR}/themes/synthwave"

    assert_file_contains "${theme_dir}/theme.json" "background"
    assert_file_contains "${theme_dir}/theme.json" "foreground"
    assert_file_contains "${theme_dir}/theme.json" "accent1"
}

# --- Error Handling Tests ---

@test "error: apply fails gracefully with missing theme directory" {
    run "$SCRIPTS_DIR/apply.sh" "this-theme-does-not-exist"
    [ "$status" -eq 1 ]
    [[ "$output" == *"not found"* ]]
}

@test "error: restore fails gracefully with no backups" {
    rm -rf "$TEST_BACKUP_DIR"/*

    run "$SCRIPTS_DIR/restore.sh"
    [ "$status" -eq 1 ]
    [[ "$output" == *"No backups"* ]]
}

# --- Cross-Tool Consistency Tests ---

@test "consistency: applied theme creates coherent environment" {
    run "$SCRIPTS_DIR/apply.sh" "synthwave"
    [ "$status" -eq 0 ]

    # All expected files should exist after apply
    assert_file_exists "$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json"
    assert_file_exists "$TEST_HOME/.p10k-themer.zsh"
    assert_file_exists "$TEST_HOME/.config/mprocs/claude.yaml"
    assert_file_exists "$TEST_HOME/.vim/colors/synthwave.vim"
    assert_file_exists "$TEST_HOME/.config/nvim/colors/synthwave.vim"
}
