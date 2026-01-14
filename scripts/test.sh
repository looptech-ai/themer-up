#!/bin/bash
# Test orchestration script - runs tests with intelligent execution

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TESTS_DIR="$PROJECT_DIR/tests"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Parse arguments
PARALLEL=false
COVERAGE=false
FAST=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--parallel)
            PARALLEL=true
            shift
            ;;
        -c|--coverage)
            COVERAGE=true
            shift
            ;;
        -f|--fast)
            FAST=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -p, --parallel   Run unit tests in parallel"
            echo "  -f, --fast       Skip integration tests (unit tests only)"
            echo "  -v, --verbose    Verbose output"
            echo "  -h, --help       Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check for BATS
if ! command -v bats &> /dev/null; then
    echo -e "${RED}Error: BATS not found${NC}"
    echo "Install with: brew install bats-core"
    exit 1
fi

echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║      Themer-Up Test Orchestrator       ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""

# Track timing
START_TIME=$(date +%s)

# ─────────────────────────────────────────────────────
# Stage 1: Static Analysis
# ─────────────────────────────────────────────────────
echo -e "${CYAN}Stage 1: Static Analysis${NC}"
echo "────────────────────────────────────────"

if command -v shellcheck &> /dev/null; then
    echo -n "  ShellCheck... "
    if "$SCRIPT_DIR/lint.sh" > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
    else
        echo -e "${RED}FAIL${NC}"
        if $VERBOSE; then
            "$SCRIPT_DIR/lint.sh"
        fi
        exit 1
    fi
else
    echo -e "  ShellCheck... ${YELLOW}SKIPPED${NC} (not installed)"
fi

# Validate JSON
echo -n "  JSON validation... "
json_errors=0
for file in "$PROJECT_DIR"/themes/*/iterm2.json "$PROJECT_DIR"/themes/*/vscode.json "$PROJECT_DIR"/themes/*/theme.json; do
    if [[ -f "$file" ]]; then
        if ! python3 -m json.tool "$file" > /dev/null 2>&1; then
            ((json_errors++))
        fi
    fi
done
if [[ $json_errors -eq 0 ]]; then
    echo -e "${GREEN}PASS${NC}"
else
    echo -e "${RED}FAIL${NC} ($json_errors files)"
    exit 1
fi

echo ""

# ─────────────────────────────────────────────────────
# Stage 2: Unit Tests
# ─────────────────────────────────────────────────────
echo -e "${CYAN}Stage 2: Unit Tests${NC}"
echo "────────────────────────────────────────"

BATS_OPTS=""
if $VERBOSE; then
    BATS_OPTS="--verbose-run"
fi

unit_tests=(
    "$TESTS_DIR/unit/backup.bats"
    "$TESTS_DIR/unit/restore.bats"
    "$TESTS_DIR/unit/apply.bats"
)

if $PARALLEL && command -v parallel &> /dev/null; then
    echo "  Running in parallel mode..."
    printf '%s\n' "${unit_tests[@]}" | parallel -j 3 "bats {} --tap" 2>&1 | while read -r line; do
        echo "    $line"
    done
else
    for test_file in "${unit_tests[@]}"; do
        if [[ -f "$test_file" ]]; then
            test_name=$(basename "$test_file" .bats)
            echo -n "  $test_name... "
            if bats "$test_file" --tap > /tmp/bats_output 2>&1; then
                passed=$(grep -c "^ok" /tmp/bats_output || echo 0)
                echo -e "${GREEN}PASS${NC} ($passed tests)"
            else
                failed=$(grep -c "^not ok" /tmp/bats_output || echo 0)
                echo -e "${RED}FAIL${NC} ($failed failed)"
                if $VERBOSE; then
                    cat /tmp/bats_output
                fi
                exit 1
            fi
        fi
    done
fi

echo ""

# ─────────────────────────────────────────────────────
# Stage 3: Integration Tests
# ─────────────────────────────────────────────────────
if ! $FAST; then
    echo -e "${CYAN}Stage 3: Integration Tests${NC}"
    echo "────────────────────────────────────────"

    if [[ -f "$TESTS_DIR/integration/theme_workflow.bats" ]]; then
        echo -n "  theme_workflow... "
        if bats "$TESTS_DIR/integration/theme_workflow.bats" --tap > /tmp/bats_output 2>&1; then
            passed=$(grep -c "^ok" /tmp/bats_output || echo 0)
            echo -e "${GREEN}PASS${NC} ($passed tests)"
        else
            failed=$(grep -c "^not ok" /tmp/bats_output || echo 0)
            echo -e "${RED}FAIL${NC} ($failed failed)"
            if $VERBOSE; then
                cat /tmp/bats_output
            fi
            exit 1
        fi
    fi

    echo ""
fi

# ─────────────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────────────
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          All Tests Passed!             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "Duration: ${DURATION}s"
