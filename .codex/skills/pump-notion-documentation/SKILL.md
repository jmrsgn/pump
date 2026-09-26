---
description: Document verified Pump development work in Notion. Use when
  asked to document today's progress, update the Pump Daily Development
  Log, record completed or ongoing work from a Pump repository, or
  synchronize affected Notion API/technical documentation with
  implemented changes.
name: pump-notion-documentation
---

# Pump Notion Documentation

Use this skill to persist verified Pump development work to the user's
Pump documentation in Notion.

The skill has two responsibilities:

1.  Maintain the date-based **Daily Development Log**.
2.  Keep affected **technical documentation** accurate when
    implementation changes APIs, contracts, architecture, persistence,
    infrastructure, or other durable system behavior.

Do not invent implementation details, tests, commits, blockers, API
contracts, or architecture decisions.

## Required Capability

This skill requires access to Notion through the Notion MCP tools configured
for the current project.

Treat MCP authentication, credential loading, and MCP server startup as
infrastructure concerns outside this skill.

Do not:

- read or inspect `config/credentials.properties`;
- read, print, log, or expose `NOTION_TOKEN`;
- attempt to authenticate with Notion;
- run `codex mcp login notion`;
- start or configure the Notion MCP server manually;
- modify `.codex/config.toml` as part of a documentation request.

If the required Notion MCP tools are unavailable or a Notion operation fails
because access is not configured, stop the documentation operation and report
the MCP/access problem without attempting to retrieve credentials.

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
  implementation changes may require API or other durable technical
  documentation updates.

For a general request such as "document what we did today", read all
three references because the implementation may require both a
development-log update and technical-documentation updates.

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
    - durable technical-documentation changes.
6.  Update the Daily Development Log according to
    `references/development-log.md`.
7.  If durable system behavior changed, update the relevant Notion
    documentation according to `references/technical-documentation.md`.
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
    - technical/API pages created, updated, or verified, if any;
    - the literal canonical Notion URL of each affected technical/API
      page;
    - verification or blockers worth mentioning;
    - anything intentionally not documented because it could not be
      verified.

## Completion Response

After processing a documentation request, always return the canonical
Notion URL for every Notion entry or page that was created, updated, or
verified.

For each affected Notion entry or page:

1.  Re-fetch it through Notion after processing.
2.  Read the canonical URL returned by Notion.
3.  Include that exact URL in the final response.

The canonical URL must appear literally in the final response, for
example:

```text
Daily Development Log:
https://app.notion.com/p/...
```

Do not satisfy this requirement by returning only a page title, page ID,
styled text, or other display text.

Do not hide the URL behind Markdown link text. The literal canonical
Notion URL must be visible in the final response so the user can open it
directly.

Use only a URL returned or verified through Notion. Never manually
construct a Notion URL from a page ID.

If no write was required because the requested information was already
documented, still re-fetch the affected entry and return its canonical
URL.

If Notion does not return a canonical URL after re-fetching the affected
content, explicitly state that the URL could not be retrieved.

Do not claim that a Notion page was updated unless the write succeeded.

If a write fails, clearly identify the failed update and do not present
it as successfully updated.

Keep the completion response concise.

## Documentation Boundaries

The Daily Development Log records **what changed on a date**.

Technical Notion pages describe **how the current system works**.

The repository's `AGENTS.md` provides **Codex engineering context and
instructions**.

Do not duplicate `AGENTS.md` into Notion. Extract only the information
necessary to keep the relevant Notion documentation accurate.

## Write Discipline

Prefer updating canonical existing Notion content over creating
duplicates.

Preserve unrelated existing content when updating a page or database
row.

Do not change Notion database schemas, property names, select options,
views, page hierarchy, or documentation structure unless the user
explicitly requests that structural change.

Do not delete, archive, or consolidate existing Notion content unless
the user explicitly requests it or the requested documentation update
makes the action safe, necessary, and unambiguous.

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
