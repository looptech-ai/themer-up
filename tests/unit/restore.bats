#!/usr/bin/env bats
# Unit tests for restore.sh

load '../test_helper'

setup() {
    setup_test_home
    export THEMER_DIR="${BATS_TEST_DIRNAME}/../.."

    # Create a mock backup to restore from
    export MOCK_BACKUP="$TEST_BACKUP_DIR/20240115_120000"
    mkdir -p "$MOCK_BACKUP"

    # Create backup files
    echo '{"theme": "backup_theme"}' > "$MOCK_BACKUP/iterm2.json"
    echo 'backup p10k config' > "$MOCK_BACKUP/p10k.zsh"
    echo 'backup mprocs config' > "$MOCK_BACKUP/mprocs.yaml"
}

teardown() {
    teardown_test_home
}

@test "restore.sh exits with error when no backups exist" {
    rm -rf "$TEST_BACKUP_DIR"/*

    run "$SCRIPTS_DIR/restore.sh"
    [ "$status" -eq 1 ]
    [[ "$output" == *"No backups found"* ]]
}

@test "restore.sh restores iTerm2 config" {
    run "$SCRIPTS_DIR/restore.sh"
    [ "$status" -eq 0 ]

    restored="$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json"
    assert_file_exists "$restored"
    assert_file_contains "$restored" "backup_theme"
}

@test "restore.sh restores p10k config" {
    run "$SCRIPTS_DIR/restore.sh"
    [ "$status" -eq 0 ]

    assert_file_exists "$TEST_HOME/.p10k-themer.zsh"
    assert_file_contains "$TEST_HOME/.p10k-themer.zsh" "backup p10k"
}

@test "restore.sh restores mprocs config" {
    run "$SCRIPTS_DIR/restore.sh"
    [ "$status" -eq 0 ]

    assert_file_exists "$TEST_HOME/.config/mprocs/claude.yaml"
    assert_file_contains "$TEST_HOME/.config/mprocs/claude.yaml" "backup mprocs"
}

@test "restore.sh uses most recent backup when multiple exist" {
    # Create an older backup with different content
    older_backup="$TEST_BACKUP_DIR/20240110_100000"
    mkdir -p "$older_backup"
    echo '{"theme": "older_theme"}' > "$older_backup/iterm2.json"

    # Create a newer backup
    newer_backup="$TEST_BACKUP_DIR/20240120_140000"
    mkdir -p "$newer_backup"
    echo '{"theme": "newer_theme"}' > "$newer_backup/iterm2.json"

    run "$SCRIPTS_DIR/restore.sh"
    [ "$status" -eq 0 ]

    # Should restore from newer backup
    restored="$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles/themer-up.json"
    assert_file_contains "$restored" "newer_theme"
}

@test "restore.sh outputs success messages" {
    run "$SCRIPTS_DIR/restore.sh"
    [ "$status" -eq 0 ]
    [[ "$output" == *"iTerm2 restored"* ]]
    [[ "$output" == *"Powerlevel10k restored"* ]]
    [[ "$output" == *"mprocs restored"* ]]
}
