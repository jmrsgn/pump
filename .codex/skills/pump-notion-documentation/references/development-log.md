# Daily Development Log

## Purpose

Maintain one consolidated Pump development entry per calendar date.

Work performed in different Pump repositories on the same date belongs
to the same Daily Development Log row. The `Repository` property is
multi-select and may contain multiple Pump repositories.

## Target Location

The log is under the Pump project's `Daily Development Log` page in
Notion.

The `Daily Development Log` is organized by year and month:

```text
Daily Development Log
└── <Year>
    └── <Month>
        └── monthly development-log database/data source
```

Each year is represented by its corresponding year database.

Each month is represented by a page within that year database. The month's
development-log database/data source is contained within that month page.

For every write:

1.  Locate the Pump `Daily Development Log` page.
2.  Identify the year database for the requested date.
3.  Identify the month page within that year.
4.  Locate the development-log database/data source contained within the
    month page.
5.  Fetch its current schema before creating or updating an entry.
6.  Use the actual property names, property types, valid select values,
    and existing row conventions returned by Notion.

Do not assume that year database, month page, monthly database, or data-source
IDs are permanent. Resolve the required structure from the verified
`Daily Development Log` hierarchy.

The current monthly development-log structure is expected to contain fields
equivalent to:

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
3.  Locate the year database corresponding to the requested date.
4.  Locate the month page for the requested date within that year.
5.  Locate the monthly development-log database/data source contained
    within that month page.
6.  Fetch the data source so the current schema, valid property values,
    and title property are known.
7.  Query the data source for entries whose `Date` equals the requested
    date.
8.  If exactly one entry exists, fetch/read it before updating and
    preserve unrelated content.
9.  If no entry exists, inspect nearby rows to preserve the database's
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

10. If multiple entries exist for the same date and the canonical entry
    is unclear, do not guess, merge, or delete automatically. Report the
    duplicates and ask the user how to proceed.
11. Merge the verified repository value into `Repository` without
    removing values already recorded for that date.
12. Merge only newly verified work into `Task / Description`.
13. Update other properties only when there is verified information
    relevant to them.
14. Preserve unrelated existing content.
15. Re-fetch the resulting entry after processing to verify its final
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

For the first documentation update for a repository on a date, include all
verified commits from that date that occurred before the documentation
request and are relevant to the work being recorded.

For subsequent documentation updates on the same date, identify newly
verified relevant commits that have not already been recorded.

Do not add the same commit more than once.

Do not include a commit merely because it appears in repository history.

Verify that it belongs to the requested date or documentation period and is
relevant to the work being documented.

### Commit Representation

Use the `Commits` property according to its live Notion type and existing
log convention.

For every newly verified commit, establish its canonical remote commit URL
from the repository's configured remote and verified commit when that URL can
be determined safely.

When the live `Commits` property supports rich text with hyperlinks, represent
each commit using the following visible-text format:

```text
<short-hash>_<repository>_<MM_DD>_<HH:mm>
```

Where:

- `<short-hash>` is the verified short Git commit hash;
- `<repository>` is the exact Notion repository value defined in
  `repository-map.md` for the repository that owns the commit;
- `<MM_DD>` is the commit's month and day;
- `<HH:mm>` is the commit's time using a 24-hour clock.

Examples:

```text
a4342b9_pump_09_28_10:14
91fd2ac_pump-auth-service_09_28_10:30
0be31d7_pump-social-service_09_28_10:35
```

Preserve the exact repository value defined in `repository-map.md`. Do not
replace hyphens in repository values with underscores or otherwise transform
the repository name.

Attach the commit's canonical remote commit URL as the hyperlink for the
entire visible label.

The date and time in the visible label must come from the verified Git commit
timestamp. Do not derive them from the documentation request time, Notion
creation time, or the position of the commit in the `Commits` property.

Use the same local-time interpretation consistently for all commits represented
on the daily entry so that their displayed timestamps and chronological order
are comparable.

Prefer this compact hyperlink representation over displaying the full commit
URL when the live Notion property and available Notion tools support it.

Do not use third-party URL-shortening services.

### Commit Ordering

Keep all commits represented in the Daily Development Log entry in
chronological order by their verified Git commit timestamps, from earliest to
latest.

Do not assume that a newly discovered commit belongs at the end of the
`Commits` property.

When newly verified commits are added, determine the timestamps of the
existing represented commits when necessary and place all represented commits
in their correct chronological positions.

For example, if the existing entry contains:

```text
aaa1234_pump-auth-service_09_28_10:14
bbb1234_pump_09_28_10:30
ccc1234_pump_09_28_10:35
```

and another verified commit is discovered with a timestamp of `10:28`, the
result must be:

```text
aaa1234_pump-auth-service_09_28_10:14
ddd1234_pump_09_28_10:28
bbb1234_pump_09_28_10:30
ccc1234_pump_09_28_10:35
```

Do not leave a newly discovered commit at the end merely because it was
documented later.

When multiple commits have the same timestamp at the displayed minute
precision, preserve their existing relative order when possible. For newly
discovered commits with the same displayed minute, use their full verified Git
timestamps to determine chronological order when that information is
available.

### Duplicate Detection and Preservation

Before updating `Commits`, compare the verified commits with the commits
already represented in the Daily Development Log entry.

Treat a commit as already represented whether it appears as:

- a full canonical commit URL;
- a rich-text hyperlink using the formatted visible label; or
- another existing representation whose hyperlink target can be verified as
  the same canonical commit URL.

Use the commit identity and canonical remote URL for duplicate detection, not
the visible label alone.

Add only newly verified commits that are not already represented.

Preserve every previously recorded verified commit when rebuilding or
reordering the `Commits` property.

Reordering existing commit references solely to maintain the required
chronological order is allowed. Do not otherwise rewrite, remove, or replace
previously recorded commit references merely to change their presentation.

If an older entry is represented by a full commit URL rather than the compact
label, it may remain in that representation. Do not convert existing commit
references solely for formatting consistency.

If the live `Commits` property or available Notion tools do not support
rich-text hyperlinks, preserve the existing log convention and use the
canonical remote commit URL directly. The chronological ordering requirement
still applies when the property and available tools allow its entries to be
ordered.

### Verification

After updating the entry, re-fetch it and verify that:

- every newly documented commit is represented;
- every previously recorded verified commit is still represented;
- no commit is represented more than once;
- the commits are ordered from earliest to latest according to their verified
  Git commit timestamps;
- each newly created compact commit label contains the correct short hash,
  repository value, date, and time;
- each newly created hyperlink targets the correct canonical remote commit URL.

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

## Missing Year or Month

If the required year database, month page, or monthly development-log
database does not exist, do not create a new year, month, database,
data source, schema, or page hierarchy automatically.

Report which part of the requested development-log structure does not
exist and ask the user whether they want the established structure
extended for that date.

Do not infer authorization to extend the structure from a general request
such as "document what we did today."
