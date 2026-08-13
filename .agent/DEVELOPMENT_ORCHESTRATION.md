# Development Orchestration

Model-independent authority for coordinating SwifQL repository work with LLMs or other implementation executors.

This file owns **roles, delegation, review, and gates**. Detailed `.artifacts/**` structure and task/report mechanics are owned by `ARTIFACTS_WORKFLOW.md`.

## Roles

### Coordinator / Reviewer

For non-trivial work, the stronger reasoning/review layer:

- restores current context from real Git, source, and stable docs;
- performs or directs focused research;
- designs and independently audits the implementation plan;
- surfaces unresolved architecture/API decisions to the maintainer before implementation;
- decomposes substantial work into numbered surgical task files;
- gives the implementation executor only a short coordinator prompt;
- independently inspects actual source, diff, Git state, and validation after execution;
- turns audit findings into focused correction task files;
- synchronizes durable stable documentation after accepted work;
- keeps commit and push as separate explicit gates.

Executor reports are evidence, never proof.

### Implementation Executor

The executor implements an already-reviewed task contract:

- reads the next numbered task immediately before work;
- modifies only its explicit scope/allowlist;
- follows closed mechanics without redesigning architecture;
- runs required validation and inspects the actual diff;
- appends execution evidence;
- continues automatically to the next already-approved task after PASS;
- stops the whole run on a genuine out-of-scope blocker.

The executor does not broaden scope merely to keep moving.

## Default Flow

```text
verify current repository state
→ focused research
→ reviewed plan
→ independent plan audit
→ numbered surgical task files
→ short coordinator prompt
→ autonomous sequential execution + append-only evidence
→ independent source/diff/Git audit
→ numbered correction wave if needed
→ independent re-audit
→ durable-doc synchronization
→ explicit commit gate
→ explicit push gate when requested
```

For non-trivial iterative work, `ARTIFACTS_WORKFLOW.md` externalizes this flow under `.artifacts/**`.

## Delegation Rule

Never send an implementation executor one huge prompt containing several independent behaviors or a full correction audit.

Instead:

1. group work into tightly coupled, independently verifiable behaviors;
2. put detailed mechanics, allowlists, validation, compatibility rules, and stop conditions into numbered task files;
3. give the executor one compact `COORDINATOR_PROMPT.md` that lists those files and the autonomous task loop.

If the coordinator prompt starts duplicating task details, fix the decomposition before execution.

## Planning Gate

Non-trivial production work requires reviewed planning when it crosses multiple files/owners or changes public API, SQL semantics, dialect behavior, preparation/binding, builders, concurrency, package/toolchain behavior, or compatibility boundaries.

The plan must be grounded in current source/Git/dependency facts and close:

- scope/non-goals;
- ownership and SQL/API semantics;
- allowed/forbidden mutation paths;
- compatibility constraints;
- relevant concurrency/lifecycle constraints;
- validation and native/live database evidence when applicable;
- stop conditions.

Known plan defects are corrected before implementation.

## Independent Audit

After executor work, independently inspect:

- complete Git status and changed paths;
- actual changed/created source and direct callers;
- relevant architecture/ownership boundaries;
- public API and legacy source compatibility;
- generated SQL fidelity and binding order where applicable;
- package/dependency changes;
- forbidden/deferred scope;
- actual validation evidence.

If defects remain, create a new focused numbered correction wave instead of one large correction prompt.

## Prompt Rules

Agent/executor prompts are written in English unless the maintainer explicitly requests otherwise.

Every prompt should identify the repository/context, role, exact scope or task files, mutation permissions, Git prohibitions, stop conditions, and expected evidence.

Do not make prompts self-contained by duplicating large task files. For artifact-driven execution, self-containment means the prompt explicitly points to the authoritative local task artifacts the executor must read.

## Context Discipline

Do not bulk-load all task files into coordinator/executor context.

- Coordinator/reviewer loads only the artifacts, stable owners, and source needed for the current planning/audit step.
- Executor reads the next numbered task immediately before executing it.
- Operational docs do not consume architecture-owner slots; architecture loading remains governed by `CONTEXT_LOADING_RULES.md`.

## Git Gates

Implementation remains unstaged unless the maintainer explicitly authorizes staging/commit scope.

Normal implementation tasks forbid staging, commit/amend, merge/rebase/reset/restore/clean/stash, branch mutation, push, unrelated fixes, and history rewriting.

Commit and push are separate phases governed by `COMMIT_RULES.md` and explicit maintainer authorization.

Good intermediate results may be committed when the maintainer explicitly authorizes that checkpoint and its exact scope. Such commits are versioning checkpoints, not permission to broaden the task or push.

## Disposable Working Memory

`.artifacts/**` may be deleted or absent on another machine. Stable workflow/architecture must remain recoverable from `AGENTS.md`, `.agent/**`, Git, source, and current maintainer instruction.

Use `ARTIFACTS_WORKFLOW.md` for artifact structure, `NEW_CHAT.md` reconstruction, task/report conventions, correction waves, and promotion of durable facts back into stable docs.
