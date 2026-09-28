# Daily Development Log

## Purpose

Maintain one consolidated Pump development entry per calendar date.

Work performed in different Pump repositories on the same date belongs
to the same Daily Development Log row. The `Repository` property is
multi-select and may contain multiple Pump repositories.

## Target Location

The log is under the Pump project's `Daily Development Log` page in
Notion.

The log is organized into monthly databases/data sources. Do not assume
that a monthly database or data-source ID is permanent.

For every write:

1.  Locate the Pump `Daily Development Log` page.
2.  Identify the database/data source for the requested month.
3.  Fetch its current schema before creating or updating an entry.
4.  Use the actual property names, property types, valid select values,
    and existing row conventions returned by Notion.

The current structure is expected to contain fields equivalent to:

- `Date`
- `Repository`
- `Task / Description`
- `Issues / Blockers`
- `Commits`
- `Status`
- `Notes`

A Notion data source also has a title property, even if that property is
unnamed or hidden in the current view. Preserve the existing title
convention when updating or creating rows.

Do not silently restructure the database if the live schema differs.

## Date Is the Daily Record Identity

For normal progress logging, the calendar date is the primary identity
of the record.

Example --- existing September 9 entry:

```text
Repository:
pump

Task / Description:
• Ongoing setup after cloning
```

Later that day, verified work is completed in `pump-coaching-service`.
Update the same September 9 entry:

```text
Repository:
pump
pump-coaching-service

Task / Description:
• Ongoing setup after cloning
• Added coaching-service updates
```

Do not create one Daily Development Log row per repository.

## Write Procedure

1.  Determine the requested date. For "today", use the user's current
    local calendar date available to the runtime/session; do not infer
    the date from commit timestamps alone.
2.  Locate the Pump `Daily Development Log`.
3.  Locate the monthly database/data source for that date.
4.  Fetch the data source so the current schema, valid property values,
    and title property are known.
5.  Query the data source for entries whose `Date` equals the requested
    date.
6.  If exactly one entry exists, fetch/read it before updating and
    preserve unrelated content.
7.  If no entry exists, inspect nearby rows to preserve the database's
    existing title/content convention, then create one.

    When creating a new Daily Development Log entry, place it at the very
    bottom of the existing monthly database table/view, after all existing
    daily entries.

    Do not rely on the entry's creation time, date value, or Notion's default
    insertion behavior to determine its visible position. Verify after
    creation that the new entry appears at the bottom of the intended monthly
    table/view.

    If the available Notion tools cannot control or verify the visible row
    position, do not claim that bottom placement was verified. Report that
    limitation to the user.

8.  If multiple entries exist for the same date and the canonical entry
    is unclear, do not guess, merge, or delete automatically. Report the
    duplicates and ask the user how to proceed.
9.  Merge the verified repository value into `Repository` without
    removing values already recorded for that date.
10. Merge only newly verified work into `Task / Description`.
11. Update other properties only when there is verified information
    relevant to them.
12. Preserve unrelated existing content.
13. Re-fetch the resulting entry after processing to verify its final
    content and retrieve its canonical Notion URL for the completion
    response.

If no write was required because the existing entry already accurately
represents the verified work, still re-fetch the entry and retrieve its
canonical Notion URL.

## Task / Description

Use concise bullet-style summaries of meaningful outcomes.

Good examples:

- Integrated training-block API calls into the Flutter coaching flow.
- Added request/response models required by training-block creation.
- Added coaching-service validation for training-block creation.

Avoid low-value implementation noise such as:

- Edited file.
- Fixed code.
- Changed imports.

Group tightly related edits into one useful development-log item when
that produces a clearer history.

Describe the implemented outcome, not every file touched.

Do not claim a feature is complete when repository evidence only shows
partial implementation.

For debugging or troubleshooting work, summarize the development outcome
rather than copying the full investigation into the daily log.

For example:

- Resolved an iOS build failure caused by a dependency version conflict.

Do not place detailed root-cause analysis, troubleshooting steps, commands,
or reusable solution instructions in `Task / Description`. When those
details represent reusable troubleshooting knowledge, route them to
`Helpers` according to the main skill and
`technical-documentation.md`.

## Duplicate Prevention

Before appending a task, compare it with the existing
`Task / Description` content.

Do not append the same accomplishment twice merely because the skill is
invoked multiple times.

Treat semantically equivalent descriptions as duplicates even when
wording differs slightly.

If later work materially extends an existing bullet, update that bullet
when doing so creates a clearer and more accurate record instead of
appending a near-duplicate.

Never remove an existing task merely because it is unrelated to the
current repository.

## Repository

Use the exact Notion repository values defined in `repository-map.md`.

The `Repository` property is cumulative for the date.

When adding the current repository, preserve all repository values
already recorded on the entry.

Do not add another repository merely because the current implementation
consumes or depends on that repository's API. The other repository must
have verified work for the requested date.

## Status

Use only status values supported by the live Notion schema.

When the schema provides `Ongoing` and `Completed`:

- `Ongoing` --- at least one material task represented by the daily
  entry is still in progress, incomplete, blocked, or has unfinished
  implementation directly related to the logged work.
- `Completed` --- all material work represented by the daily entry is
  complete to the extent claimed and available verification supports
  that conclusion.

Do not infer `Completed` merely because code was edited, committed, or
pushed.

Because the status belongs to the entire daily row, preserve `Ongoing`
if another task already recorded on that row is still ongoing.

If the existing row's overall status cannot be determined confidently
from available evidence, preserve its current status rather than
guessing.

## Issues / Blockers

Record only actual blockers or unresolved issues relevant to the
documented work.

Do not invent a blocker from warnings, TODOs, or failing commands
without understanding whether they block the work being documented.

Preserve existing blockers unless evidence or the user establishes that
they are resolved.

If a blocker is verified as resolved, update the wording so the log does
not continue presenting it as active. Do not remove unrelated blockers.

## Commits

Record verified commits associated with the work being documented.

When processing a development-log request, inspect the current repository's
commit history and the commits already represented in the Daily Development
Log entry.

Identify relevant commits belonging to the requested documentation period
that are not already recorded.

For a normal "document what we did today" request, inspect relevant commits
from the current local calendar date up to the time of the documentation
request. Do not assume that only the latest commit should be documented.

For subsequent documentation requests on the same date, preserve previously
recorded commits and append only newly verified commits that are not already
represented.

For the first documentation update for a repository on a date, include all
verified commits from that date that occurred before the documentation
request and are relevant to the work being recorded.

For subsequent documentation updates on the same date, append only newly
verified commits that have not already been recorded in the Daily Development
Log.

Example:

```text
Commit A
Commit B
↓
Documentation request
↓
Recorded commits:
Commit A
Commit B

Commit C
↓
Later documentation request
↓
Recorded commits:
Commit A
Commit B
Commit C
```

Do not add the same commit more than once.

Do not include a commit merely because it appears in repository history.

Verify that it belongs to the requested date or documentation period and is
relevant to the work being documented.

Use the `Commits` property according to its live Notion type and existing
log convention.

For every newly verified commit, establish its canonical remote commit URL
from the repository's configured remote and verified commit when that URL can
be determined safely.

When the live `Commits` property supports rich text with hyperlinks, represent
each commit using its short Git commit hash as the visible text and attach the
canonical remote commit URL as the hyperlink.

Example:

```text
a4342b9
6afef60
5efab21
```

Each displayed short hash should link to its corresponding canonical remote
commit URL.

Prefer this compact hyperlink representation over displaying the full commit
URL when the live Notion property and available Notion tools support it.

Do not use third-party URL-shortening services.

Before updating `Commits`, compare the verified commits with the commits
already represented in the Daily Development Log entry. Treat a commit as
already represented whether it appears as a full commit URL or as a rich-text
hyperlink whose target is that commit's canonical remote URL.

Append only newly verified commits that are not already represented.

Preserve all previously recorded commit references when adding newly verified
commits.

If the live `Commits` property or available Notion tools do not support
rich-text hyperlinks, preserve the existing log convention and use the
canonical remote commit URL directly.

After updating the entry, re-fetch it and verify that every newly documented
commit is represented and that previously recorded commit references were
preserved.

Do not include repository names in the Commits property merely to identify
which repository owns a commit. Repository identity is represented by the
`Repository` property.

Do not fabricate a commit URL from an assumed repository, organization,
branch, host, or remote.

If relevant work is still uncommitted, do not invent a commit reference.

Do not change the Notion schema merely to accommodate commit information.

## Notes

Use `Notes` for useful context that does not belong in the main task
summary, such as:

- important implementation qualifications;
- verification/test results worth preserving;
- migration or configuration considerations;
- concise follow-up context;

Do not duplicate `Task / Description` in `Notes`.

## Missing Month

If the requested month's database does not exist, do not create a new
monthly database, data source, schema, or page hierarchy automatically.

Report that the requested month's development-log structure does not exist
and ask the user whether they want the established monthly structure
extended for that month.

Do not infer authorization to create a new month from a general request such
as "document what we did today."
