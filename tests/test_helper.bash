#!/usr/bin/env bash
# BATS test helper - shared setup and utilities for all tests

# Project paths - resolve from this helper file's location
_HELPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMER_DIR="$(cd "${_HELPER_DIR}/.." && pwd)"
export THEMER_DIR
export SCRIPTS_DIR="${THEMER_DIR}/scripts"
export THEMES_DIR="${THEMER_DIR}/themes"

# Test fixture paths (isolated from real user configs)
export TEST_HOME="${BATS_TMPDIR}/themer-test-home"
export TEST_BACKUP_DIR="${TEST_HOME}/.themer-up-backup"

# Override HOME for isolated testing
setup_test_home() {
    export ORIGINAL_HOME="$HOME"
    export HOME="$TEST_HOME"

    # Export THEMER_DIR so scripts can find theme files
    export THEMER_DIR

    # Export backup dir override so scripts use test location
    export THEMER_BACKUP_DIR="$TEST_BACKUP_DIR"

    # Create mock directory structure
    mkdir -p "$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles"
    mkdir -p "$TEST_HOME/Library/Application Support/Code/User"
    mkdir -p "$TEST_HOME/.config/mprocs"
    mkdir -p "$TEST_HOME/.config/nvim/colors"
    mkdir -p "$TEST_HOME/.vim/colors"
    mkdir -p "$TEST_HOME/.themer-up-backup"

    # Create minimal .zshrc and .vimrc
    touch "$TEST_HOME/.zshrc"
    touch "$TEST_HOME/.vimrc"
}

teardown_test_home() {
    export HOME="$ORIGINAL_HOME"
    unset THEMER_BACKUP_DIR
    rm -rf "$TEST_HOME"
}

# Assertions
assert_file_exists() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "Expected file to exist: $file" >&2
        return 1
    fi
}

assert_file_not_exists() {
    local file="$1"
    if [[ -f "$file" ]]; then
        echo "Expected file NOT to exist: $file" >&2
        return 1
    fi
}

assert_file_contains() {
    local file="$1"
    local pattern="$2"
    if ! grep -q "$pattern" "$file" 2>/dev/null; then
        echo "Expected file $file to contain: $pattern" >&2
        return 1
    fi
}

assert_dir_exists() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        echo "Expected directory to exist: $dir" >&2
        return 1
    fi
}

# Theme validation helpers
theme_file_count() {
    local theme="$1"
    find "${THEMES_DIR}/${theme}" -type f | wc -l | tr -d ' '
}

validate_theme_structure() {
    local theme="$1"
    local theme_dir="${THEMES_DIR}/${theme}"

    [[ -f "${theme_dir}/theme.json" ]] || return 1
    [[ -f "${theme_dir}/iterm2.json" ]] || return 1
}

# Mock external commands for isolation
create_mock_commands() {
    local mock_bin="${TEST_HOME}/bin"
    mkdir -p "$mock_bin"
    export PATH="${mock_bin}:$PATH"

    # Mock code command
    cat > "${mock_bin}/code" << 'EOF'
#!/bin/bash
echo "Mock: code $@"
exit 0
EOF
    chmod +x "${mock_bin}/code"
}
