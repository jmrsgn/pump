# Technical Documentation Updates

## Purpose

Keep Pump's durable Notion technical documentation synchronized with the
implemented system.

This workflow complements the Daily Development Log:

-   the Daily Development Log records **what changed on a date**;
-   technical documentation describes **how the system currently
    works**.

Update technical documentation only when verified implementation changes
make existing durable documentation incomplete, inaccurate, or missing.

## When to Update Technical Documentation

Review relevant technical documentation when verified changes affect one
or more of:

-   public or internal REST APIs;
-   request or response contracts;
-   contract-level validation behavior;
-   authentication or authorization behavior;
-   cross-service contracts;
-   persisted entities, relationships, or durable data models;
-   service ownership or boundaries;
-   application architecture;
-   infrastructure, deployment, or environment behavior;
-   configuration that developers/operators need to understand;
-   meaningful Flutter/backend integration behavior.

Do not update durable technical pages for formatting-only changes,
refactors with no documented behavioral impact, temporary experiments,
or implementation details that do not belong in the existing
documentation.

## Find the Canonical Page First

Before editing or creating technical documentation:

1.  Search within the Pump Notion documentation for the relevant
    feature, domain, or topic.
2.  Fetch the strongest matching existing page or pages.
3.  Inspect their current structure, terminology, and scope.
4.  Identify the canonical page that owns the information.
5.  Update that page rather than creating a parallel version.

Do not create pages such as `Coaching APIs v2`, `New Coaching API`, or
`Updated Endpoints` merely because an existing page needs an update.

If no appropriate page exists, create a new technical page only when the
user's documentation request authorizes it and the correct
parent/location can be determined confidently. Otherwise report that a
canonical destination could not be established.

## API Documentation

When an endpoint is introduced, materially changed, deprecated,
replaced, or removed, synchronize the canonical API documentation with
the verified implementation.

As applicable, document:

-   HTTP method;
-   route/path;
-   purpose;
-   authentication/authorization requirements;
-   path parameters;
-   query parameters;
-   request body and field requirements;
-   response contract;
-   relevant HTTP status codes;
-   validation and error behavior;
-   cross-service behavior when it is part of the API contract.

Inspect the implementation sources needed to verify the contract, such
as controllers/routes, DTOs, validation rules, security configuration,
service behavior, exception handling, and tests.

Never infer a request field, response field, status code, validation
rule, or authorization requirement from naming alone.

If implementation evidence is incomplete, document only the verified
portion and identify the uncertainty in the completion summary.

When an endpoint is removed or replaced, update stale canonical
documentation rather than simply appending the new endpoint while
leaving the old one presented as current.

## Data-Model Documentation

Update data-model documentation when persisted entities, relationships,
ownership, or important durable constraints change.

Distinguish clearly between:

-   persistence entities/models;
-   API DTOs/contracts;
-   Flutter/client models.

Do not present a DTO field as a database column, or a client model as a
backend persistence model, unless that relationship is verified.

## Architecture and Service Boundaries

Update architecture documentation only for actual architectural changes.

Examples include:

-   moving ownership of data between services;
-   introducing or removing a cross-service dependency;
-   changing authentication/authorization flow;
-   introducing a new infrastructure component;
-   changing a durable integration or communication pattern;
-   changing deployment/runtime architecture.

Do not label ordinary feature implementation as an architecture change.

Respect service ownership defined by the current repository's
`AGENTS.md` and verified implementation.

## Flutter/Backend Synchronization

When documenting Flutter integration with a backend API, verify both
sides only when both repositories are actually available to inspect.

If only one side is available:

-   document what can be verified from that repository;
-   use existing authoritative documentation only as supporting context;
-   do not claim that the unavailable repository was changed;
-   do not add the unavailable repository to the Daily Development Log
    merely because it participates in the integration.

## Preserve Existing Documentation Style

Follow the canonical Notion page's existing:

-   terminology;
-   heading hierarchy;
-   level of detail;
-   endpoint grouping;
-   table/list conventions;
-   formatting style.

Make the smallest coherent update that leaves the page accurate and
understandable.

Do not rewrite unrelated sections merely to improve wording.

Preserve useful existing context that remains correct.

## Conflicts and Uncertainty

If verified current code and existing Notion documentation conflict,
update stale Notion documentation when the implementation is clearly
authoritative for the requested documentation task, and mention the
corrected mismatch in the completion summary when material.

If `AGENTS.md`, implementation, tests, or existing documentation
conflict in a way that suggests the implementation itself may be wrong
or incomplete, do not silently rewrite documentation to legitimize the
discrepancy. Surface the conflict for user review.

Do not resolve ambiguous architecture or contract decisions by
assumption.

## Relationship to the Daily Development Log

Keep the two documentation layers intentionally different.

Example Daily Development Log entry:

``` text
• Added training-block creation API and integrated the Flutter coaching flow.
```

Example API documentation content:

``` text
POST /...
Authentication: ...
Request: ...
Response: ...
Validation/errors: ...
```

Do not paste full API specifications, entity schemas, or architecture
explanations into the Daily Development Log.

Conversely, do not turn canonical technical pages into chronological
work journals.
