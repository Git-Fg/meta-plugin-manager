# Core Ralph Tenets

Ralph follows six foundational principles that ensure reliable orchestration:

## 1. **Fresh Context Is Reliability**
Each iteration clears context. Re-read specs, plan, code every cycle. Optimize for the "smart zone" (40-60% of ~176K usable tokens).

**Best Practice:**
- Re-read all files and specifications every iteration
- Clear context prevents assumptions
- Explicit state > implicit assumptions

## 2. **Backpressure Over Prescription**
Don't prescribe how; create gates that reject bad work. Tests, typechecks, builds, lints. For subjective criteria, use LLM-as-judge with binary pass/fail.

**Best Practice:**
- Quality gates: tests/lint/typecheck must pass
- Binary pass/fail criteria (no gray areas)
- Let Ralph figure out HOW, enforce WHAT

## 3. **The Plan Is Disposable**
Regeneration costs one planning loop. Cheap. Never fight to save a plan.

**Best Practice:**
- If a plan isn't working, regenerate it
- Don't attach to plans emotionally
- Quick to create, quick to discard

## 4. **Disk Is State, Git Is Memory**
Memories (.agent/memories.md) and Tasks (.agent/tasks.jsonl) are the handoff mechanisms. No sophisticated coordination needed.

**Best Practice:**
- Use files for persistent state
- Git as memory across sessions
- Simple handoffs > complex coordination

## 5. **Steer With Signals, Not Scripts**
The codebase is the instruction manual. When Ralph fails a specific way, add a sign for next time. The prompts you start with won't be the prompts you end with.

**Best Practice:**
- Use existing code as reference
- Add feedback signals when failures occur
- Iterate on prompts based on observed behavior

## 6. **Let Ralph Ralph**
Sit on the loop, not in it. Tune like a guitar, don't conduct like an orchestra.

**Best Practice:**
- Autonomous iteration > micromanagement
- Set quality gates, let Ralph work
- Trust the process

## Anti-Patterns to Avoid

❌ **Building features into the orchestrator** that agents can handle
❌ **Complex retry logic** (fresh context handles recovery)
❌ **Detailed step-by-step instructions** (use backpressure instead)
❌ **Scoping work at task selection time** (scope at plan creation instead)
❌ **Assuming functionality is missing** without code verification
