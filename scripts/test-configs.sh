#!/bin/bash
# Test that AI coding agent configurations are properly loaded
# Deterministic validation of Claude Code, Cursor CLI, and Codex CLI configs
# Run after configure-all.sh to validate configs are working

set -e

CONFIG_DIR="$HOME/.ai-agent-config"
BASE_CONFIG_DIR="$CONFIG_DIR/base-config"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

check_symlink() {
  local link_path="$1"
  local expected_target="$2"

  if [ ! -L "$link_path" ]; then
    echo "FAIL: $link_path is not a symlink"
    return 1
  fi

  local actual_target
  actual_target="$(readlink "$link_path")"
  if [ "$actual_target" != "$expected_target" ]; then
    echo "FAIL: $link_path points to $actual_target (expected $expected_target)"
    return 1
  fi

  return 0
}

check_exists() {
  local path="$1"

  if [ ! -e "$path" ]; then
    echo "FAIL: Missing $path"
    return 1
  fi

  return 0
}

check_contains() {
  local path="$1"
  local needle="$2"

  if ! grep -q "$needle" "$path"; then
    echo "FAIL: $path does not contain $needle"
    return 1
  fi

  return 0
}

echo "=== Testing AI Agent Configurations ==="
echo ""
echo "Running deterministic validation checks..."
echo ""

# Run configure-all first to ensure configs are up to date
echo "1. Updating configurations..."
"$CONFIG_DIR/scripts/configure-all.sh"
echo ""

echo "2. Running validation tests..."
echo ""
all_passed=true

claude_ok=true
codex_ok=true
cursor_ok=true
cursor_reason=""

if ! check_symlink "$HOME/.claude/CLAUDE.md" "$BASE_CONFIG_DIR/AGENTS.md"; then
  claude_ok=false
fi

if ! check_symlink "$HOME/.claude/skills" "$BASE_CONFIG_DIR/skills"; then
  claude_ok=false
fi

if ! check_exists "$HOME/.claude/skills/file-editing-task"; then
  claude_ok=false
fi

# Verify AGENTS.md contains expected content (the file-editing-task skill reference)
if ! check_contains "$BASE_CONFIG_DIR/AGENTS.md" "file-editing-task"; then
  claude_ok=false
fi

if ! check_symlink "$CODEX_HOME/AGENTS.md" "$BASE_CONFIG_DIR/AGENTS.md"; then
  codex_ok=false
fi

if ! check_symlink "$CODEX_HOME/skills/file-editing-task" "$BASE_CONFIG_DIR/skills/file-editing-task"; then
  codex_ok=false
fi

if ! check_exists "$CODEX_HOME/skills/file-editing-task/SKILL.md"; then
  codex_ok=false
fi

if ! check_symlink "$HOME/.cursor/skills" "$BASE_CONFIG_DIR/skills"; then
  cursor_ok=false
fi

if ! check_exists "$HOME/.cursor/skills/file-editing-task"; then
  cursor_ok=false
fi

# Verify AGENTS.md contains expected content (the file-editing-task skill reference)
# Note: Cursor user rules must be set manually, but we can verify the source file
if ! check_contains "$BASE_CONFIG_DIR/AGENTS.md" "file-editing-task"; then
  cursor_ok=false
  cursor_reason="AGENTS.md missing expected content"
fi

if [ "$claude_ok" = true ]; then
  echo "Claude Code: PASS"
else
  echo "Claude Code: FAIL"
  all_passed=false
fi

if [ "$codex_ok" = true ]; then
  echo "Codex CLI: PASS"
else
  echo "Codex CLI: FAIL"
  all_passed=false
fi

if [ "$cursor_ok" = true ]; then
  echo "Cursor CLI: PASS (skills linked; user rules must be set manually)"
else
  if [ -n "$cursor_reason" ]; then
    echo "Cursor CLI: FAIL ($cursor_reason)"
  else
    echo "Cursor CLI: FAIL"
  fi
  all_passed=false
fi

if [ "$all_passed" = true ]; then
  echo "All tests passed"
else
  echo "Some tests failed"
fi

echo ""
echo "=== Validation complete ==="
