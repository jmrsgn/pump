---
description: Document verified Pump development work in Notion. Use when
  asked to document today's progress, update the Pump Daily Development
  Log, record completed or ongoing work from a Pump repository, or
  synchronize affected durable Pump documentation with verified
  development changes.
name: pump-notion-documentation
---

# Pump Notion Documentation

Use this skill to persist verified Pump development work to the user's
Pump documentation in Notion.

The skill has two responsibilities:

1. Maintain the date-based **Daily Development Log**.
2. Keep affected **durable Pump documentation** accurate when verified
   development work changes features, APIs, frontend behavior, architecture,
   persistence, infrastructure, releases, or reusable troubleshooting
   knowledge.

Do not invent implementation details, tests, commits, blockers, API
contracts, architecture decisions, root causes, or verification results.

## Required Capability

This skill requires access to Notion through the installed ChatGPT plugin's
Notion tools in the current session. Use the tools that are available; the
plugin connection and authentication are managed outside this repository.

Do not:

- read, print, log, or expose credentials or tokens;
- attempt to authenticate with Notion or configure its connection manually;
- create repository-local MCP configuration or credential files.

If the Notion tools are unavailable or a Notion operation fails because access
is not configured, stop the documentation operation and report the access
problem without attempting to retrieve credentials.

Never include credentials, tokens, secrets, or authentication material in
Notion documentation.

## Supporting References

Read the references needed for the request:

- `references/repository-map.md` --- identify the current Pump
  repository and its exact Notion `Repository` value.
- `references/development-log.md` --- use for today's progress,
  development-log updates, or general requests to document work
  completed during a date.
- `references/technical-documentation.md` --- use when verified
  implementation or troubleshooting findings may require durable Pump
  documentation updates outside the Daily Development Log.

For a general request such as "document what we did today", read all
three references because the verified work may require both a
development-log update and durable documentation updates.

## Repository Instructions

Read and follow the current repository's `AGENTS.md` before interpreting
repository architecture, ownership, conventions, constraints, or
documentation boundaries.

Each Pump repository maintains its own `AGENTS.md` as the authoritative
Codex context for that repository.

If this skill conflicts with repository instructions or higher-priority
instructions, do not silently resolve the conflict. Follow the
higher-priority instruction and surface any material documentation
conflict to the user.

## Evidence and Source of Truth

Inspect the actual repository state before documenting work.

Use, as applicable:

- the current Codex session and work performed during it;
- Git repository identity and root;
- `git status`;
- unstaged and staged diffs;
- relevant commits and commit history;
- changed source files;
- tests and their actual results;
- the current repository's `AGENTS.md`;
- existing Notion documentation before modifying it.

The user's request and conversation may explain intent, but they are not
proof that a planned change was implemented.

Likewise, the mere presence of a diff or commit is not proof that it
belongs to the requested date. Use the current session, relevant
history, timestamps, and user context together when determining the
requested period.

Do not document planned work as completed work.

When the working tree no longer contains the relevant diff because work
was already committed, inspect relevant commits/history rather than
concluding that no work occurred.

## Workflow

1.  Read the current repository's `AGENTS.md` when available.
2.  Identify the current repository using
    `references/repository-map.md`.
3.  Inspect the current session, Git state, relevant implementation,
    commits, and verification evidence.
4.  Determine what was actually accomplished during the requested
    period, normally today.
5.  Separate findings into:
    - development-log facts;
    - durable documentation changes.
6.  Update the Daily Development Log according to
    `references/development-log.md`.
7.  If durable documentation is affected, route and update it according to
    `references/technical-documentation.md` and the Documentation Boundaries
    defined below.
8.  Re-fetch each affected Notion record or page after processing the
    documentation request to:
    - verify the resulting content;
    - confirm that the intended update succeeded;
    - retrieve its canonical Notion URL for the completion response.
9.  If no write was required because the requested information was
    already documented, still fetch and verify the relevant Notion
    record or page and retrieve its canonical Notion URL.
10. Give the user a concise completion summary containing:
    - the Daily Development Log entry created, updated, or verified;
    - the literal canonical Notion URL of that entry, exactly as
      returned or verified through Notion;
    - repository values recorded;
    - other documentation pages created, updated, or verified, if any;
    - the literal canonical Notion URL of each affected documentation page;
    - verification or blockers worth mentioning;
    - anything intentionally not documented because it could not be
      verified.

## Completion Response

After processing a documentation request, always return the canonical
Notion URL for every Notion entry or page that was created, updated, or
verified.

For each affected Notion entry or page:

1. Re-fetch it through Notion after processing.
2. Read the canonical URL returned by Notion.
3. Include that exact URL in the final response.

The canonical URL must appear literally in the final response.

When only the Daily Development Log was affected, use a concise format
such as:

```text
Daily Development Log:
https://app.notion.com/p/...
```

When additional Pump documentation was created, updated, or verified,
include each affected page separately using a short descriptive label that
identifies the documentation that was affected.

```text
Daily Development Log:
https://app.notion.com/p/...

Coaching API Documentation:
https://app.notion.com/p/...

Training Block Data Model:
https://app.notion.com/p/...
```

Use the actual purpose or title of the affected documentation when choosing
the label. Prefer specific labels such as:

- Authentication API Documentation
- Coaching API Documentation
- Social API Documentation
- Training Block Data Model
- Authentication Architecture
- Infrastructure Documentation

Do not use a generic label such as Technical API changes when a more
specific description of the affected page is available.

If multiple documentation pages were affected, return every affected page and its canonical URL separately. Do not collapse multiple pages into a single generic documentation result.

Do not include additional documentation sections in the completion response
when no additional documentation was created, updated, or verified.

Do not satisfy the URL requirement by returning only a page title, page ID,
styled text, or other display text.

Do not hide the URL behind Markdown link text. The literal canonical
Notion URL must be visible in the final response so the user can open it
directly.

Use only a URL returned or verified through Notion. Never manually
construct a Notion URL from a page ID.

If no write was required because the requested information was already
documented, still re-fetch the affected entry and return its canonical URL.

If Notion does not return a canonical URL after re-fetching the affected
content, explicitly state that the URL could not be retrieved.

Do not claim that a Notion page was updated unless the write succeeded.

If a write fails, clearly identify the failed update and do not present it
as successfully updated.

Keep the completion response concise.

## Documentation Boundaries

The Pump Notion documentation contains the following documentation areas:

- `Daily Development Log`
- `Feature Tracker`
- `Backend API Tracker`
- `Frontend Tracker`
- `Version / Release Log`
- `Helpers`

These are the Pump documentation areas this skill should consider when
searching for, reading, creating, updating, or verifying development
documentation.

### Documentation Responsibilities

`Daily Development Log` records **what changed on a date**.

`Feature Tracker` describes the current state and implementation status of
Pump features.

`Backend API Tracker` contains durable backend API documentation, including
implemented endpoints, request and response contracts, validation,
authentication and authorization behavior, and other backend API behavior.

`Frontend Tracker` contains durable frontend documentation, including
implemented screens, flows, client-side integrations, and other relevant
frontend behavior.

`Version / Release Log` records version and release information when the
documented work affects a Pump version or release.

`Helpers` contains reusable troubleshooting knowledge discovered while
developing Pump. It should preserve useful problems and their verified
solutions when that knowledge is likely to help diagnose or resolve the
same or a similar issue in the future.

Examples appropriate for `Helpers` include:

- difficult or non-obvious bugs and their verified solutions;
- dependency, framework, SDK, runtime, or tool version incompatibilities;
- build, package, migration, or environment issues;
- platform-specific development issues;
- configuration problems and their verified resolutions;
- recurring development pitfalls;
- debugging findings that explain why an issue occurred;
- workarounds that remain relevant to future Pump development.

Do not use `Helpers` as a duplicate Daily Development Log.

A Daily Development Log entry should record that an issue was investigated
or resolved on a particular date. `Helpers` should preserve the reusable
technical knowledge needed to understand and solve that issue in the future.

The repository's `AGENTS.md` provides **Codex engineering context and
instructions** for the current repository.

Do not duplicate `AGENTS.md` into Notion. Extract only the information
necessary to keep the appropriate Pump documentation accurate.

### Documentation Routing

Route documentation according to the type of information being recorded:

- date-based development progress → `Daily Development Log`;
- feature implementation or feature-status changes → `Feature Tracker`;
- backend API or backend contract changes → `Backend API Tracker`;
- Flutter/frontend behavior or client integration changes → `Frontend Tracker`;
- version or release changes → `Version / Release Log`;
- reusable issues, troubleshooting findings, and verified solutions → `Helpers`.

A single development task may require updates to more than one documentation
area when the verified work affects multiple documentation responsibilities.

For example, resolving a difficult Flutter dependency incompatibility may
require:

- a concise record of the completed work in `Daily Development Log`;
- durable troubleshooting details and the verified solution in `Helpers`;
- an update to `Frontend Tracker` only if the resulting implementation
  materially changes documented frontend behavior.

Do not update a documentation area merely because it is related to the
feature or issue. Update it only when the verified work changes information
owned by that area.

Not every documentation request requires updates to every applicable area.
Update only the areas whose existing documentation is materially affected by
the verified work.

When the user explicitly asks to document a reusable issue, bug, solution, or
troubleshooting finding, evaluate `Helpers` even when the implementation
itself does not require another durable documentation update.

### Helpers Documentation Rules

Before creating new troubleshooting documentation in `Helpers`, search for
an existing page or entry describing the same or a substantially similar
problem.

If an appropriate existing entry exists, update it when the new information
improves, corrects, or extends the existing troubleshooting knowledge.

Create a new entry only when the issue represents distinct reusable
knowledge and no suitable existing entry exists.

When documenting an issue in `Helpers`, include only information that can be
verified from the development work. As applicable, capture:

- the problem or observed behavior;
- the relevant context or environment;
- the verified root cause, when established;
- the solution or workaround that resolved the issue;
- relevant dependency, framework, SDK, runtime, or tool versions;
- important commands or configuration changes when they are safe and useful;
- verification showing that the solution worked;
- limitations or follow-up considerations that remain relevant.

Do not claim a suspected cause as the root cause unless it was actually
verified.

Do not preserve large debugging transcripts, raw logs, failed experiments,
or investigation noise when a concise explanation of the problem and
solution is sufficient.

### Canonical Documentation

Within the appropriate documentation area, find and update the canonical
existing page or record whenever one exists rather than creating duplicate
documentation.

Preserve the existing organization, terminology, and formatting conventions
of that documentation area.

When no appropriate destination exists and creating new documentation is
authorized by the documentation workflow, create it only when the correct
documentation area and parent location can be determined confidently.

## Write Discipline

Preserve unrelated existing content when updating a page or database
row.

Do not change Notion database schemas, property names, select options,
views, page hierarchy, or documentation structure unless the user
explicitly requests that structural change.

Do not delete, archive, move, or consolidate existing Notion content unless
the user explicitly requests that destructive or structural action.

A normal documentation request does not authorize deletion, archival,
movement, or consolidation of existing Notion content.

When the correct write target is ambiguous, stop before making a
destructive or structural change and ask the user.

## Safety and Integrity

Never write secrets or sensitive credentials to Notion, including:

- passwords;
- API keys;
- access tokens;
- refresh tokens;
- JWTs;
- private keys;
- connection credentials;
- secret environment-variable values.

Do not expose sensitive values discovered in diffs, configuration files,
logs, local environment files, or command output.

When documentation requires mentioning a secret-backed setting, document
the setting/key name and purpose only, never its secret value.
