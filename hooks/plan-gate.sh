#!/usr/bin/env bash
# PreToolUse hook on ExitPlanMode: block the first plan per session and feed
# Claude the deepener skill body; the next ExitPlanMode in that session passes.
# Install in ~/.claude/settings.json:
#   "hooks": { "PreToolUse": [ { "matcher": "ExitPlanMode", "hooks": [
#     { "type": "command", "command": "~/.claude/skills/deepener/hooks/plan-gate.sh" } ] } ] }
input=$(cat)
tool=$(printf '%s' "$input" | sed -n 's/.*"tool_name" *: *"\([^"]*\)".*/\1/p')
[ "$tool" = "ExitPlanMode" ] || exit 0
# Single source of truth: the questions live in SKILL.md, after the frontmatter.
body=$(awk 'n>=2; /^---$/{n++}' "$(dirname "$0")/../SKILL.md" 2>/dev/null)
[ -n "$body" ] || exit 0  # fail open: no questions to ask, don't block
sid=$(printf '%s' "$input" | sed -n 's/.*"session_id" *: *"\([^"]*\)".*/\1/p')
# ponytail: markers live in TMPDIR and are never cleaned; OS wipes them on reboot
marker="${TMPDIR:-/tmp}/deepener-${sid:-unknown}"
[ -e "$marker" ] && exit 0
# Fail open: without a marker every plan would block forever.
touch "$marker" 2>/dev/null || exit 0
printf 'Apply this to your plan, revise it, then call ExitPlanMode again.\n%s\n' "$body" >&2
exit 2
