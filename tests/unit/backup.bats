#!/usr/bin/env bats
# Unit tests for backup.sh

load '../test_helper'

setup() {
    setup_test_home

    # Patch THEMER_DIR in the script for testing
    export THEMER_DIR="${BATS_TEST_DIRNAME}/../.."

    # Create files that would normally exist in user's home
    echo '{"theme": "old"}' > "$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json"
    echo 'old p10k config' > "$TEST_HOME/.p10k-themer.zsh"
    echo 'old mprocs config' > "$TEST_HOME/.config/mprocs/claude.yaml"
}

teardown() {
    teardown_test_home
}

@test "backup.sh creates timestamped backup directory" {
    run "$SCRIPTS_DIR/backup.sh"
    [ "$status" -eq 0 ]

    # Check that a backup directory was created
    backup_count=$(find "$TEST_BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
    [ "$backup_count" -ge 1 ]
}

@test "backup.sh copies iTerm2 config when present" {
    run "$SCRIPTS_DIR/backup.sh"
    [ "$status" -eq 0 ]

    # Find the latest backup
    latest_backup=$(ls -dt "$TEST_BACKUP_DIR"/*/ 2>/dev/null | head -1)

    assert_file_exists "${latest_backup}iterm2.json"
    assert_file_contains "${latest_backup}iterm2.json" "old"
}

@test "backup.sh copies p10k config when present" {
    run "$SCRIPTS_DIR/backup.sh"
    [ "$status" -eq 0 ]

    latest_backup=$(ls -dt "$TEST_BACKUP_DIR"/*/ 2>/dev/null | head -1)
    assert_file_exists "${latest_backup}p10k.zsh"
}

@test "backup.sh copies mprocs config when present" {
    run "$SCRIPTS_DIR/backup.sh"
    [ "$status" -eq 0 ]

    latest_backup=$(ls -dt "$TEST_BACKUP_DIR"/*/ 2>/dev/null | head -1)
    assert_file_exists "${latest_backup}mprocs.yaml"
}

@test "backup.sh handles missing files gracefully" {
    # Remove all config files
    rm -f "$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json"
    rm -f "$TEST_HOME/.p10k-themer.zsh"
    rm -f "$TEST_HOME/.config/mprocs/claude.yaml"

    run "$SCRIPTS_DIR/backup.sh"
    [ "$status" -eq 0 ]

    # Backup dir should still be created (possibly empty)
    assert_dir_exists "$TEST_BACKUP_DIR"
}

@test "backup.sh keeps only last 5 backups" {
    # Create 6 old backup directories
    for i in {1..6}; do
        old_backup="$TEST_BACKUP_DIR/2024010${i}_120000"
        mkdir -p "$old_backup"
        touch "$old_backup/iterm2.json"
        sleep 0.1  # Ensure different timestamps
    done

    run "$SCRIPTS_DIR/backup.sh"
    [ "$status" -eq 0 ]

    # Should have at most 5 backup directories (5 old + 1 new = 6, then prune to 5)
    backup_count=$(find "$TEST_BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
    [ "$backup_count" -le 5 ]
}
