# Themer-Up Makefile
# Orchestrates testing, linting, and development tasks

.PHONY: all test test-unit test-integration lint clean install-deps help

# Default target
all: lint test

# ─────────────────────────────────────────────────────
# Testing Targets
# ─────────────────────────────────────────────────────

## Run all tests (linting + unit + integration)
test: lint test-unit test-integration

## Run unit tests only (fast feedback)
test-unit:
	@echo "Running unit tests..."
	@bats tests/unit/*.bats --tap

## Run integration tests only
test-integration:
	@echo "Running integration tests..."
	@bats tests/integration/*.bats --tap

## Run tests in parallel (requires GNU parallel)
test-parallel:
	@./scripts/test.sh --parallel

## Run tests with verbose output
test-verbose:
	@./scripts/test.sh --verbose

## Run fast tests only (skip integration)
test-fast:
	@./scripts/test.sh --fast

# ─────────────────────────────────────────────────────
# Linting Targets
# ─────────────────────────────────────────────────────

## Run shellcheck on all scripts
lint:
	@./scripts/lint.sh

## Validate all JSON config files
lint-json:
	@echo "Validating JSON files..."
	@for f in themes/*/iterm2.json themes/*/vscode.json themes/*/theme.json; do \
		if [ -f "$$f" ]; then python3 -m json.tool "$$f" > /dev/null && echo "  ✓ $$f"; fi; \
	done

## Validate all YAML config files
lint-yaml:
	@echo "Validating YAML files..."
	@for f in themes/*/*.yaml; do \
		if [ -f "$$f" ]; then yamllint -d relaxed "$$f" && echo "  ✓ $$f"; fi; \
	done

# ─────────────────────────────────────────────────────
# Development Targets
# ─────────────────────────────────────────────────────

## Install development dependencies
install-deps:
	@echo "Installing dependencies..."
	@which bats > /dev/null || brew install bats-core
	@which shellcheck > /dev/null || brew install shellcheck
	@which yamllint > /dev/null || pip install yamllint
	@echo "Done!"

## Apply synthwave theme (default)
apply:
	@./scripts/apply.sh synthwave

## Create a backup of current configs
backup:
	@./scripts/backup.sh

## Restore from latest backup
restore:
	@./scripts/restore.sh

## Clean temporary test files
clean:
	@echo "Cleaning temporary files..."
	@rm -rf /tmp/themer-test-*
	@rm -f /tmp/bats_output
	@echo "Done!"

# ─────────────────────────────────────────────────────
# CI Simulation
# ─────────────────────────────────────────────────────

## Simulate full CI pipeline locally
ci: lint lint-json test-unit test-integration
	@echo ""
	@echo "✅ CI simulation passed!"

# ─────────────────────────────────────────────────────
# Help
# ─────────────────────────────────────────────────────

## Show this help message
help:
	@echo "Themer-Up Development Commands"
	@echo "══════════════════════════════"
	@echo ""
	@grep -E '^##' Makefile | sed 's/## /  /'
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Testing:"
	@echo "  make test           - Run all tests"
	@echo "  make test-unit      - Run unit tests only"
	@echo "  make test-fast      - Skip integration tests"
	@echo "  make test-parallel  - Run tests in parallel"
	@echo ""
	@echo "Linting:"
	@echo "  make lint           - Run shellcheck"
	@echo "  make lint-json      - Validate JSON files"
	@echo ""
	@echo "Development:"
	@echo "  make install-deps   - Install dev dependencies"
	@echo "  make apply          - Apply synthwave theme"
	@echo "  make ci             - Simulate CI locally"
