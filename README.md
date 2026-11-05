# deepener

A [Claude Code](https://claude.com/claude-code) skill that makes a task deeper, not bigger.

Before Claude rewrites a task or plan it has to answer four questions:

1. What would a top professional in this field do here that you are not asking for?
2. What is the rawest material they would start from, instead of what has already been digested for you?
3. Which specific methods and tools would they use?
4. What independent check, other than Claude or you, would show the result is right: a test, a dataset, a statute section, a third-party reviewer?

Each answer must name something concrete enough to look up or run. Scope stays the same size: every addition replaces something. Where an answer depends on current state (a file exists, a source is reachable), Claude checks rather than assumes.

Two shapes of use:

- **On a task you gave**: Claude rewrites your prompt and asks before executing it.
- **On a plan Claude proposed**: Claude rewrites the plan.

## Install

```bash
git clone https://github.com/45black-Limited/deepener.git ~/.claude/skills/deepener
```

Invoke with `/deepener`, or append it to a request (`... /deepener`). Claude also reaches for it on its own before a task where the approach is a judgement call or a mistake would be expensive.

`SKILL.desktop.md` is the same skill with the `AskUserQuestion` confirmation step, for hosts that render that widget. `SKILL.md` keeps the exchange in plain text.

## Optional plan gate

`hooks/plan-gate.sh` is a `PreToolUse` hook on `ExitPlanMode`. It blocks the first plan in each session, feeds Claude the four questions, and lets the revised plan through. It fails open: no `SKILL.md`, no writable temp dir, or any other hiccup means it never blocks.

```json
"hooks": { "PreToolUse": [ { "matcher": "ExitPlanMode", "hooks": [
  { "type": "command", "command": "~/.claude/skills/deepener/hooks/plan-gate.sh" } ] } ] }
```

Hook config binds at session start, so restart Claude Code after adding it. Test:

```bash
bash ~/.claude/skills/deepener/hooks/plan-gate.test.sh   # prints PASS
```
