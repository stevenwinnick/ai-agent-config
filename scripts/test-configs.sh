#!/bin/bash
# Functional test for AI coding agent configurations
# Runs each agent in headless mode to validate that it can see the global user config and the exploring-and-discovering skill

TIMEOUT=120

GLOBAL_USER_CONFIG_QUESTION='What is the instruction in the "About You" section of your global user config file? Reply with ONLY the instruction text, nothing else.'
SKILL_QUESTION='What skill should you use when the information needed to complete a task is not already known? Reply with ONLY the skill name, nothing else.'

# Bash-native timeout. GNU `timeout` causes some CLI tools (e.g. claude) to hang
# due to process group / signal handling incompatibilities.
run_with_timeout() {
  local timeout_secs="$1"
  shift
  # Run the command in the background
  "$@" &
  local pid=$!
  # Spawn a watchdog that kills the command after the timeout.
  # Redirect stdout/stderr so the watchdog's sleep doesn't hold the
  # command substitution pipe open after the command finishes.
  ( sleep "$timeout_secs" && kill "$pid" 2>/dev/null ) &>/dev/null &
  local watchdog=$!
  # Wait for the command to finish (or be killed)
  wait "$pid" 2>/dev/null
  local exit_code=$?
  # Clean up the watchdog if the command finished before the timeout
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
  # Capture stdout via command substitution; discard stderr
  output=$(run_with_timeout "$TIMEOUT" "${cmd[@]}" 2>/dev/null) || exit_code=$?

  # 137 = SIGKILL (128+9), 143 = SIGTERM (128+15) — both mean the watchdog killed the process
  if [ "$exit_code" -eq 137 ] || [ "$exit_code" -eq 143 ]; then
    echo "$test_name: FAIL (timed out after ${TIMEOUT}s)"
    return 1
  elif [ "$exit_code" -ne 0 ]; then
    echo "$test_name: FAIL (exit code $exit_code)"
    return 1
  fi

  # Case-insensitive, whitespace-insensitive substring match
  local response
  response=$(echo "$output" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')
  local expected_lower
  expected_lower=$(echo "$expected" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')

  if [[ "$response" == *"$expected_lower"* ]]; then
    echo "$test_name: PASS"
    return 0
  else
    echo "$test_name: FAIL (expected response containing \"$expected\", got \"$output\")"
    return 1
  fi
}

echo "=== Functional Test: AI Agent Configurations ==="
all_passed=true

# --- Claude Code ---
echo "Claude Code:"
claude_ok=true

if ! run_test "Claude Code" "global user config loaded" "help" \
  claude -p --no-session-persistence "$GLOBAL_USER_CONFIG_QUESTION"; then
  claude_ok=false
fi

if ! run_test "Claude Code" "exploring-and-discovering skill" "discover" \
  claude -p --no-session-persistence "$SKILL_QUESTION"; then
  claude_ok=false
fi

if [ "$claude_ok" = false ]; then all_passed=false; fi

# --- Codex CLI ---
echo "Codex CLI:"
codex_ok=true

if ! run_test "Codex CLI" "global user config loaded" "help" \
  codex exec --skip-git-repo-check "$GLOBAL_USER_CONFIG_QUESTION"; then
  codex_ok=false
fi

if ! run_test "Codex CLI" "exploring-and-discovering skill" "discover" \
  codex exec --skip-git-repo-check "$SKILL_QUESTION"; then
  codex_ok=false
fi

if [ "$codex_ok" = false ]; then all_passed=false; fi

# --- Summary ---
echo "=== Results ==="
if [ "$all_passed" = true ]; then
  echo "All tests passed"
else
  echo "Some tests failed"
  exit 1
fi
