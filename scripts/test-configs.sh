#!/bin/bash
# Functional test for AI coding agent configurations
# Runs each agent in headless mode to validate that it can see AGENTS.md and the coding-task skill
# Run after configure-all.sh to validate configs are working

set -e

CONFIG_DIR="$HOME/.ai-agent-config"
TIMEOUT=60

# Scratch directory for test outputs
SCRATCH_DIR=$(mktemp -d)
trap 'rm -rf "$SCRATCH_DIR"' EXIT

AGENTS_QUESTION='My AGENTS.md instructions say I am "an instance of an AI agent being directed by" someone. Who is that person? Reply with ONLY their first name, nothing else.'
SKILL_QUESTION='Do you have access to a skill called "coding-task"? Reply with ONLY "yes" or "no", nothing else.'

run_test() {
  local agent_name="$1"
  local test_name="$2"
  local expected="$3"
  local output_file="$4"
  shift 4
  local cmd=("$@")

  if ! timeout "$TIMEOUT" "${cmd[@]}" > "$output_file" 2>/dev/null; then
    echo "  $test_name: FAIL (command timed out or errored)"
    return 1
  fi

  local response
  response=$(tr '[:upper:]' '[:lower:]' < "$output_file" | tr -d '[:space:]')
  local expected_lower
  expected_lower=$(echo "$expected" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')

  if [[ "$response" == *"$expected_lower"* ]]; then
    echo "  $test_name: PASS"
    return 0
  else
    echo "  $test_name: FAIL (expected \"$expected\", got \"$(cat "$output_file")\")"
    return 1
  fi
}

echo "=== Functional Test: AI Agent Configurations ==="
echo ""

# Run configure-all first to ensure configs are up to date
echo "1. Updating configurations..."
"$CONFIG_DIR/scripts/configure-all.sh"
echo ""

echo "2. Running functional tests..."
echo ""
all_passed=true

# --- Claude Code ---
echo "Claude Code:"
claude_ok=true

if ! run_test "Claude Code" "AGENTS.md loaded" "steven" "$SCRATCH_DIR/claude_agents.txt" \
  claude -p --no-session-persistence "$AGENTS_QUESTION"; then
  claude_ok=false
fi

if ! run_test "Claude Code" "coding-task skill" "yes" "$SCRATCH_DIR/claude_skill.txt" \
  claude -p --no-session-persistence "$SKILL_QUESTION"; then
  claude_ok=false
fi

if [ "$claude_ok" = false ]; then all_passed=false; fi
echo ""

# --- Codex CLI ---
echo "Codex CLI:"
codex_ok=true

if ! run_test "Codex CLI" "AGENTS.md loaded" "steven" "$SCRATCH_DIR/codex_agents.txt" \
  codex exec --skip-git-repo-check "$AGENTS_QUESTION"; then
  codex_ok=false
fi

if ! run_test "Codex CLI" "coding-task skill" "yes" "$SCRATCH_DIR/codex_skill.txt" \
  codex exec --skip-git-repo-check "$SKILL_QUESTION"; then
  codex_ok=false
fi

if [ "$codex_ok" = false ]; then all_passed=false; fi
echo ""

# --- Cursor CLI ---
echo "Cursor CLI:"
cursor_ok=true

if ! run_test "Cursor CLI" "AGENTS.md loaded" "steven" "$SCRATCH_DIR/cursor_agents.txt" \
  cursor agent -p "$AGENTS_QUESTION"; then
  cursor_ok=false
fi

if ! run_test "Cursor CLI" "coding-task skill" "yes" "$SCRATCH_DIR/cursor_skill.txt" \
  cursor agent -p "$SKILL_QUESTION"; then
  cursor_ok=false
fi

if [ "$cursor_ok" = false ]; then all_passed=false; fi
echo ""

# --- Summary ---
echo "=== Results ==="
if [ "$all_passed" = true ]; then
  echo "All tests passed"
else
  echo "Some tests failed"
  exit 1
fi
