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

-   `Date`
-   `Repository`
-   `Task / Description`
-   `Issues / Blockers`
-   `Commits`
-   `Status`
-   `Notes`

A Notion data source also has a title property, even if that property is
unnamed or hidden in the current view. Preserve the existing title
convention when updating or creating rows.

Do not silently restructure the database if the live schema differs.

## Date Is the Daily Record Identity

For normal progress logging, the calendar date is the primary identity
of the record.

Example --- existing September 9 entry:

``` text
Repository:
pump

Task / Description:
• Ongoing setup after cloning
```

Later that day, verified work is completed in `pump-coaching-service`.
Update the same September 9 entry:

``` text
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
8.  If multiple entries exist for the same date and the canonical entry
    is unclear, do not guess, merge, or delete automatically. Report the
    duplicates and ask the user how to proceed.
9.  Merge the verified repository value into `Repository` without
    removing values already recorded for that date.
10. Merge only newly verified work into `Task / Description`.
11. Update other properties only when there is verified information
    relevant to them.
12. Preserve unrelated existing content.
13. Re-fetch or otherwise verify the resulting entry when practical.

## Task / Description

Use concise bullet-style summaries of meaningful outcomes.

Good examples:

-   Integrated training-block API calls into the Flutter coaching flow.
-   Added request/response models required by training-block creation.
-   Added coaching-service validation for training-block creation.

Avoid low-value implementation noise such as:

-   Edited file.
-   Fixed code.
-   Changed imports.

Group tightly related edits into one useful development-log item when
that produces a clearer history.

Describe the implemented outcome, not every file touched.

Do not claim a feature is complete when repository evidence only shows
partial implementation.

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

-   `Ongoing` --- at least one material task represented by the daily
    entry is still in progress, incomplete, blocked, or has unfinished
    implementation directly related to the logged work.
-   `Completed` --- all material work represented by the daily entry is
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

Use the `Commits` property according to its live Notion type and the
existing log convention.

Add a commit URL only when a real URL can be established from repository
information.

Do not fabricate a GitHub URL from a commit hash or remote assumption.

If the work is uncommitted, do not invent a commit reference.

If a single-value `Commits` property already contains a value, do not
overwrite it with a different commit merely because the skill is running
from another repository. Preserve the existing value unless the live
schema/convention supports a correct merged representation.

When multiple commit references cannot be represented safely without
changing the schema, preserve the existing property and mention
additional verified commit context in `Notes` only if that matches the
established log convention.

## Notes

Use `Notes` for useful context that does not belong in the main task
summary, such as:

-   important implementation qualifications;
-   verification/test results worth preserving;
-   migration or configuration considerations;
-   concise follow-up context;
-   additional verified commit context when the `Commits` property
    cannot safely hold it.

Do not duplicate `Task / Description` in `Notes`.

## Missing Month

If the requested month's database does not exist, do not silently create
a new monthly database, data source, or schema.

Tell the user that the month is missing and ask whether they want the
existing monthly structure extended.
