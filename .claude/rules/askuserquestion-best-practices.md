# AskUserQuestion Best Practices

**Core Principle: Recognition over Generation**

Users are faster at recognizing the correct answer than generating it from scratch. Structure interactions to leverage this human strength.

IMPORTANT : ALL THE FOLLOWING EXAMPLE ARE THE "GLOBAL LOGIC" YOU MUST ADAPT THEM TO YOUR ASKUSERQUESTION TOOL TO PROVIDE OPTIMAL AND ACTIONABLE PROPOSITIONS. THE USER SHOULDNT HAVE TO WRITE ANYTHING. 

---

## The Cognitive Load Principle

**Question Selection Hierarchy:**

1. **First: Infer** - Can you deduce the answer from context, files, logs, or analysis?
2. **Second: Investigate** - Can tools provide the information without user input?
3. **Third: Ask** - Only ask when inference and investigation are insufficient

**Recognition Question**: "Would the user need to think to answer this, or can they just recognize/validate?"

---

## Question Strategy Framework

### High-Quality Questions (Ask These)

**Validation-Based Questions** - User recognizes correctness:
- "I infer the issue is X. Is that right?" ✅
- "My analysis shows A, B, or C. Which matches your situation?" ✅
- "Should I proceed with approach 1 or 2?" ✅

**Binary Confirmations** - User confirms/corrects:
- "Is this the file you meant?" ✅
- "Did the error occur after the latest deploy?" ✅
- "Should I prioritize speed or quality?" ✅

### Low-Quality Questions (Avoid These)

**Open-Ended Generation** - User must think/remember:
- "What do you think is wrong?" ❌
- "How should we approach this?" ❌
- "What's the best way to fix this?" ❌

**Information Recall** - User must remember facts:
- "What was the error message?" ❌
- "Which files were changed?" ❌
- "What's the expected behavior?" ❌

---

## Before Asking: Investigation Protocol

**Never ask without first:**

1. **Check Context** - Review conversation history
2. **Read Files** - Examine relevant code/configuration
3. **Use Tools** - Run commands, search, analyze
4. **Apply Frameworks** - Use analytical models to infer

**Recognition Test**: "Could I find this information without asking?"

---

## Question Structure Patterns

### Pattern 1: Inference → Validation

**Structure:**
```
[Investigation Phase]
"Based on my analysis of [evidence], I believe [inference].
Is this correct, or should I investigate something else?"
```

**Examples:**
- "I've reviewed the logs. The 500 error occurs in payment-gateway.js. Is this the module you meant?"
- "Analyzing commit history shows this broke in commit abc123. Should I revert it?"

### Pattern 2: Options → Recognition

**Structure:**
```
"Which of these matches your situation?
1. [Option A - specific description]
2. [Option B - specific description]
3. [Option C - specific description]"
```

**Examples:**
- "The app won't start. Which error do you see?
  1. 'Module not found' (missing dependency)
  2. 'Port already in use' (process conflict)
  3. 'Permission denied' (access issue)"

### Pattern 3: Context-Aware Choice

**Structure:**
```
"[Context-based question] based on [specific evidence].
Which path should I take?
1. [Path A - for scenario X]
2. [Path B - for scenario Y]
3. [Path C - for scenario Z]"
```

**Examples:**
- "The database connection failed. Based on your error logs showing 'timeout after 30s':
  1. Increase timeout (network issue)
  2. Add connection pooling (load issue)
  3. Check firewall rules (security issue)"

---

## Progressive Disclosure Strategy

**Iterative Narrowing:**

1. **Top-Level** - Broad categories first
   - "Is this a technical or business problem?"

2. **Mid-Level** - Drill down based on answer
   - "If technical: Is it code, config, or infrastructure?"

3. **Bottom-Level** - Specific actions
   - "If config: Should I check env vars, database, or API keys?"

**Each question eliminates a massive section of the problem tree.**

---

## User Effort Minimization

### Zero-Typing Standard

**Target:** User responds with single word/number, ideally just "1", "2", or "yes"

**Achieve this by:**
- Present clearly numbered options
- Make options self-explanatory
- Include escape hatch: "None of these / Other"
- Format for easy scanning

### Question Flow Design

**Before:**
```
User: "The API is slow"
AI: "Can you describe the performance issue?"
User: [Types detailed description,回忆 symptoms, thinks about specifics]
```

**After:**
```
User: "The API is slow"
AI: "I'll investigate the logs to narrow this down..."
[Analysis]
AI: "Based on the logs, which pattern matches?
1. Slow responses (2-5s) during peak hours
2. Timeouts (30s) for specific endpoints
3. Gradual slowdown over time"
User: [Recognizes pattern, types "1"]
```

---

## Tool Usage Before Questions

**Use these tools first:**

| Information Needed | Tools to Try | Example |
|-------------------|--------------|---------|
| Error details | `Bash`, `Read`, `Grep` | Run logs, check recent commits |
| Code structure | `Glob`, `LSP`, `Read` | Map files, find functions |
| Configuration | `Read`, `Grep` | Check env vars, config files |
| Dependencies | `Bash` | Check package.json, requirements.txt |
| System state | `Bash` | Check processes, disk space, network |

**Question Test:** "Can a tool find this information?"

---

## Anti-Pattern Recognition

### Anti-Pattern 1: Premature Questions

**❌ Wrong:**
```
User: "Build is failing"
AI: "What's the error message?"
```

**✅ Right:**
```
User: "Build is failing"
AI: [Checks logs] "The error is 'fs-extra version mismatch'. Should I rollback or upgrade?"
```

### Anti-Pattern 2: Question Stacking

**❌ Wrong:**
```
AI: "Is this a frontend or backend issue?"
User: "Backend"
AI: "Is it the API or database?"
User: "API"
AI: "Is it authentication or data processing?"
User: "Auth"
AI: "Is it login or registration?"
```

**✅ Right:**
```
AI: [Analyzes] "The backend API auth is failing. Should I check JWT tokens or OAuth flow?"
```

### Anti-Pattern 3: Information Re-asking

**❌ Wrong:**
```
AI: "What files did you change?"
[User answers]
AI: "What was the error message?"
[User answers]
AI: "When did this start happening?"
```

**✅ Right:**
```
AI: [Reads git log, checks errors] "The error started after your auth.js change. Should I revert it or debug the token logic?"
```

---

## Context-Specific Patterns

### Debugging Questions

**Use diagnostic patterns:**
```
"Which error stage are you seeing?
1. Won't compile (syntax/dependency)
2. Crashes on startup (config/env)
3. Runtime errors (logic bugs)"
```

### Implementation Questions

**Use approach patterns:**
```
"For this refactor, should I prioritize:
1. Speed (minimal changes, quick deploy)
2. Quality (thorough testing, slow but safe)
3. Innovation (new architecture, experimental)?"
```

### Scope Questions

**Use expansion patterns:**
```
"You mentioned feature X. Should I also implement:
1. Just X (focused scope)
2. X + Y (natural extension)
3. Complete module (broader scope)?"
```

---

## Quality Checklist

Before asking any question, verify:

- [ ] Can I infer this from context/tools?
- [ ] Can the user just recognize the answer?
- [ ] Is this eliminating a large problem space?
- [ ] Would the answer change my strategy?
- [ ] Is this the most specific question I can ask?
- [ ] Does this require zero/one-word response?

**If no to most questions, investigate more before asking.**

---

## Summary

**The AskUserQuestion Hierarchy:**

1. **Infer** from context, files, logs
2. **Investigate** using available tools
3. **Ask** for validation/recognition, not generation
4. **Structure** questions to eliminate problem space
5. **Minimize** user effort (zero-typing standard)

**Remember:** Users are recognition engines, not generation engines. Design questions that let them recognize solutions, not generate them.

For strategic reasoning patterns, see `deductive-reasoning` skill.
