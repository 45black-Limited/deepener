#!/usr/bin/env bash
# Black-box check for plan-gate.sh: stdin hook JSON -> exit code + stderr.
set -u
cd "$(dirname "$0")"
TMPDIR="$(mktemp -d)" || { echo "FAIL: mktemp"; exit 1; }
export TMPDIR
fail=0
run() { err=$(printf '%s' "$1" | ./plan-gate.sh 2>&1 >/dev/null); code=$?; }
check() { [ "$1" = "$2" ] || { echo "FAIL: $3 (got '$1', want '$2')"; fail=1; }; }

run '{"session_id":"s1","tool_name":"ExitPlanMode"}'
check "$code" 2 "first plan in session blocks"
for q in "top professional" "rawest material" "methods and tools" "other than you or me"; do
  case "$err" in *"$q"*) ;; *) echo "FAIL: stderr missing '$q'"; fail=1 ;; esac
done

run '{"session_id":"s1","tool_name":"ExitPlanMode"}'
check "$code" 0 "second plan in same session passes"

run '{"session_id":"s2","tool_name":"ExitPlanMode"}'
check "$code" 2 "new session blocks again"

run '{"session_id":"s3","tool_name":"Bash"}'
check "$code" 0 "other tool passes"

err=$(printf '%s' '{"session_id":"s4","tool_name":"ExitPlanMode"}' | TMPDIR=/nonexistent/dir ./plan-gate.sh 2>&1 >/dev/null); code=$?
check "$code" 0 "unwritable TMPDIR fails open"

lone="$TMPDIR/lone"; mkdir -p "$lone/hooks" && cp plan-gate.sh "$lone/hooks/"
err=$(printf '%s' '{"session_id":"s5","tool_name":"ExitPlanMode"}' | "$lone/hooks/plan-gate.sh" 2>&1 >/dev/null); code=$?
check "$code" 0 "missing SKILL.md fails open"

rm -rf "$TMPDIR"
[ "$fail" = 0 ] && echo "PASS" || exit 1
