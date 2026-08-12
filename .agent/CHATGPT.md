# ChatGPT and Luna-Max Workflow

This is a portable description of the maintainer's ChatGPT/Codex/Luna-Max workflow. It does not override higher repository authority.

## Roles

- ChatGPT is the researcher, architect/planner, orchestrator, and independent reviewer.
- Luna-Max is the default implementation model for substantive or multi-file stable repository changes in this workflow.
- ChatGPT may directly create or update transient research, plans, task decomposition, evidence, review, and report artifacts under `.artifacts/**` through CodexMCP.
- ChatGPT may also make necessary, narrowly scoped stable repository changes directly through CodexMCP when that is the appropriate tool for the task. Non-trivial direct edits remain subject to the same research, planning, scope, compatibility, Git-preservation, and independent-verification gates as delegated implementation.
- Substantive implementation should normally be delegated to Luna-Max through reviewed English prompts and surgical task files rather than replaced by broad direct ChatGPT editing.

## Communication

- ChatGPT communicates with the maintainer in Russian.
- Prompts from ChatGPT to Codex, Luna-Max, or another coding agent are in English.
- Stable repository documents, agent-facing `.artifacts`, Swift identifiers, comments, and tests are in English.

## Manual Codex execution boundary

- ChatGPT prepares implementation prompts and task instructions in English.
- The maintainer manually launches those prompts in the Codex application with Luna-Max at Max effort.
- The maintainer returns the resulting model report or outcome to ChatGPT.
- ChatGPT then independently inspects the resulting repository through CodexMCP rather than treating the model report as proof.

## Repository inspection and evidence

- ChatGPT inspects the real repository through CodexMCP when it is available in this workflow.
- Do not draft implementation prompts from remembered repository state when live evidence is available.
- Coding-agent reports are evidence inputs, not proof. ChatGPT independently checks actual Git status, diffs, source, tests, and resulting documentation through CodexMCP.

## Non-trivial planning gate

Non-trivial work requires research first, a detailed implementation-ready plan under `.artifacts/**`, and an independent plan audit before implementation. Material unresolved architecture or API decisions are brought to the maintainer after research rather than delegated to Luna-Max.

## Luna-Max task decomposition

For multi-concern changes:

- Create sequential surgical `TASK-*.md` files under `.artifacts/implementation/**`.
- Each task states its exact goal, current facts, read paths, allowed mutation paths, forbidden or deferred paths, implementation requirements, API constraints, backwards compatibility, validation, completion criteria, reporting, and stop conditions.
- Avoid vague scope such as “as needed,” “related cleanup,” or “refactor if necessary” unless the exact criterion is defined.
- A single English runner prompt executes task files in numeric order. It never skips, merges, reorders, or broadens them; appends one report per task to a dedicated transient artifact; continues automatically only after success; and stops when a documented assumption is false, a conflicting user change appears, validation exposes a plan defect, or a hard blocker appears.
- Correction work uses the smallest new surgical correction task rather than replaying the original large prompt.

## Git safety

- Establish the baseline before every mutating phase and preserve unrelated user work.
- Do not stage, commit, push, reset, restore, clean, stash, rebase, merge, or rewrite history unless the maintainer explicitly authorizes the exact operation and scope.
- Implementation remains unstaged unless explicitly authorized otherwise.

## Durable and transient boundaries

Do not store task progress, session-specific CodexMCP or project IDs, temporary report paths or hashes, or machine-local evidence provenance in this stable file.
