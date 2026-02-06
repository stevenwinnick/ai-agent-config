#!/bin/bash
# Functional test for AI coding agent configurations
# Runs each agent in headless mode to validate that it can see AGENTS.md and the explore-and-discover skill

TIMEOUT=120

AGENTS_QUESTION='What is the instruction in the "About You" section of your global AGENTS.md? Reply with ONLY the instruction text, nothing else.'
SKILL_QUESTION='What skill should you use when the information needed to complete a task is not already known? Reply with ONLY the skill name, nothing else.'

run_with_timeout() {
  local timeout_secs="$1"
  shift
  "$@" &
  local pid=$!
  ( sleep "$timeout_secs" && kill "$pid" 2>/dev/null ) &
  local watchdog=$!
  wait "$pid" 2>/dev/null
  local exit_code=$?
  kill "$watchdog" 2>/dev/null
  wait "$watchdog" 2>/dev/null
  return "$exit_code"
}

run_test() {
  local agent_name="$1"
  local test_name="$2"
  local expected="$3"
  shift 3
  local cmd=("$@")

  local output=""
  local exit_code=0
  output=$(run_with_timeout "$TIMEOUT" "${cmd[@]}" 2>/dev/null) || exit_code=$?

  # 137 = killed by SIGKILL (128+9), 143 = killed by SIGTERM (128+15) — treat as timeout
  if [ "$exit_code" -eq 137 ] || [ "$exit_code" -eq 143 ]; then
    echo "  $test_name: FAIL (timed out after ${TIMEOUT}s)"
    return 1
  elif [ "$exit_code" -ne 0 ]; then
    echo "  $test_name: FAIL (exit code $exit_code)"
    return 1
  fi

  local response
  response=$(echo "$output" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')
  local expected_lower
  expected_lower=$(echo "$expected" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')

  if [[ "$response" == *"$expected_lower"* ]]; then
    echo "  $test_name: PASS"
    return 0
  else
    echo "  $test_name: FAIL (expected response containing \"$expected\", got \"$output\")"
    return 1
  fi
}

echo "=== Functional Test: AI Agent Configurations ==="
echo ""
all_passed=true

# --- Claude Code ---
echo "Claude Code:"
claude_ok=true

if ! run_test "Claude Code" "AGENTS.md loaded" "help" \
  claude -p --no-session-persistence "$AGENTS_QUESTION"; then
  claude_ok=false
fi

if ! run_test "Claude Code" "explore-and-discover skill" "discover" \
  claude -p --no-session-persistence "$SKILL_QUESTION"; then
  claude_ok=false
fi

if [ "$claude_ok" = false ]; then all_passed=false; fi
echo ""

# --- Codex CLI ---
echo "Codex CLI:"
codex_ok=true

if ! run_test "Codex CLI" "AGENTS.md loaded" "help" \
  codex exec --skip-git-repo-check "$AGENTS_QUESTION"; then
  codex_ok=false
fi

if ! run_test "Codex CLI" "explore-and-discover skill" "discover" \
  codex exec --skip-git-repo-check "$SKILL_QUESTION"; then
  codex_ok=false
fi

if [ "$codex_ok" = false ]; then all_passed=false; fi
echo ""

# --- Cursor CLI ---
echo "Cursor CLI:"
cursor_ok=true

if ! run_test "Cursor CLI" "AGENTS.md loaded" "help" \
  cursor agent -p "$AGENTS_QUESTION"; then
  cursor_ok=false
fi

if ! run_test "Cursor CLI" "explore-and-discover skill" "discover" \
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
