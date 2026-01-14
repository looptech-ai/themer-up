#!/bin/bash
# Run shellcheck on all shell scripts

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}Running ShellCheck on themer-up scripts...${NC}"
echo ""

# Find all shell scripts
scripts=(
    "$PROJECT_DIR/scripts/apply.sh"
    "$PROJECT_DIR/scripts/backup.sh"
    "$PROJECT_DIR/scripts/restore.sh"
)

# Also check test files
test_files=()
while IFS= read -r -d '' file; do
    test_files+=("$file")
done < <(find "$PROJECT_DIR/tests" -name "*.bash" -print0 2>/dev/null)

all_files=("${scripts[@]}" "${test_files[@]}")

failed=0
passed=0

for file in "${all_files[@]}"; do
    if [[ -f "$file" ]]; then
        echo -n "Checking $(basename "$file")... "
        # Use -S warning to only fail on warnings/errors, not style/info
        if shellcheck -S warning "$file" 2>/dev/null; then
            echo -e "${GREEN}OK${NC}"
            ((passed++))
        else
            echo -e "${RED}FAILED${NC}"
            ((failed++))
            # Show details
            shellcheck -S warning "$file" || true
        fi
    fi
done

echo ""
echo "────────────────────────────"
echo -e "Passed: ${GREEN}${passed}${NC}"
echo -e "Failed: ${RED}${failed}${NC}"

if [[ $failed -gt 0 ]]; then
    exit 1
fi

echo -e "${GREEN}All checks passed!${NC}"
