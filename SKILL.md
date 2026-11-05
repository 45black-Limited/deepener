---
name: deepener
description: Deepen a task or plan without widening it, by asking what an expert would do, the rawest material they would start from, their methods and tools, and what independent check would prove the result. Use before starting a task where the approach is a judgement call or a mistake would be expensive, before presenting a plan, or when the user asks for deeper, not bigger.
---

I want a deeper version of this task, not a bigger one. Keep scope the same size: each addition replaces something.

Before rewriting it:

1. Say what a top professional in this field would do here that I'm not asking for.
2. Name the rawest material they would start from instead of what has already been digested for me.
3. Name the specific methods and tools they would use.
4. Say what independent check, other than you or me, would show the result is right: a test, a dataset, a statute section, a third-party reviewer.

Then rewrite the task to ask for exactly that.

- If the target is a task I gave, rewrite my prompt and ask before executing it.
- If the target is a plan you proposed, rewrite the plan.

Done when each answer names something concrete enough to look up or run, and the rewritten task asks for all four.

Keep each answer short. Where an answer depends on current state (a file exists, a source is reachable), check it rather than assume it.
