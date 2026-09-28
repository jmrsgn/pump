# Technical Documentation Updates

## Purpose

Keep Pump's durable Notion documentation synchronized with the verified
implemented system and reusable development knowledge.

This workflow complements the Daily Development Log:

- the `Daily Development Log` records **what changed on a date**;
- `Feature Tracker` describes the current state of Pump features;
- `Backend API Tracker` describes current backend APIs and backend behavior;
- `Frontend Tracker` describes current Flutter/frontend behavior and integrations;
- `Version / Release Log` records actual Pump version and release information;
- `Helpers` preserves reusable troubleshooting knowledge and verified solutions.

Update durable documentation only when verified development work makes
existing documentation incomplete, inaccurate, or missing, or when reusable
troubleshooting knowledge should be preserved according to the main skill.

Do not update a documentation area merely because it is related to the work.
Update only the areas whose documented information is materially affected.

## Documentation Routing

Determine the appropriate Notion documentation area from the verified
information being documented.

### Feature Tracker

Use `Feature Tracker` when verified implementation changes the documented
state, scope, or behavior of a Pump feature.

Examples include:

- introducing a new feature;
- materially extending an existing feature;
- changing feature behavior or scope;
- completing a previously documented implementation stage;
- removing or replacing documented feature behavior.

Do not update `Feature Tracker` for implementation noise, refactors with no
feature-level impact, or work that does not change the documented state of a
feature.

### Backend API Tracker

Use `Backend API Tracker` when verified backend implementation changes:

- public or internal REST APIs;
- request or response contracts;
- contract-level validation behavior;
- authentication or authorization behavior;
- cross-service API contracts;
- persisted entities, relationships, or durable backend data models when
  those are part of the existing backend documentation;
- backend service behavior that developers need to understand.

Use the API, data-model, and architecture rules below when applicable.

### Frontend Tracker

Use `Frontend Tracker` when verified Flutter/frontend implementation changes:

- screens or meaningful UI flows;
- navigation or user flows;
- client-side API integration;
- client request/response handling;
- frontend models that materially affect documented behavior;
- state-management behavior that belongs in the existing frontend
  documentation;
- meaningful user-facing behavior.

Do not update `Frontend Tracker` for formatting-only changes, trivial visual
adjustments, import changes, or refactors with no documented frontend
behavioral impact.

### Infrastructure and Configuration Documentation

Pump does not currently define a dedicated infrastructure documentation area
in this workflow.

When verified infrastructure, deployment, environment, or durable
configuration changes require documentation, first search the existing Pump
documentation to identify the canonical page or area that already owns that
information.

Examples include:

- Docker or Compose behavior;
- Kubernetes resources and runtime behavior;
- ingress or service routing;
- deployment configuration;
- environment-specific behavior;
- infrastructure dependencies;
- developer/operator configuration that must remain documented.

Update existing canonical infrastructure documentation when its ownership and
location can be determined confidently.

Do not force infrastructure information into `Backend API Tracker`,
`Frontend Tracker`, or another unrelated area merely because no dedicated
tracker exists.

If durable infrastructure documentation is required but no canonical
destination exists, report that gap rather than inventing a new documentation
area or structure without user approval.

Use `Version / Release Log` separately when the verified work also represents
an actual release or deployment event according to that log's established
convention.

### Version / Release Log

Use `Version / Release Log` only when verified work represents an actual
version or release event that belongs in the existing release documentation.

Examples include:

- a version being prepared or released;
- an existing release being updated with verified release information;
- release-specific changes that the current log convention records.

Do not create a release entry merely because development work was completed
or committed.

Do not infer a version, release number, release date, deployment, or release
status without evidence.

### Helpers

Use `Helpers` for reusable troubleshooting knowledge according to the
`Helpers Documentation Rules` in the main `SKILL.md`.

Examples include:

- difficult or non-obvious bugs and their verified solutions;
- dependency or version incompatibilities;
- build, package, migration, or environment problems;
- platform-specific development issues;
- recurring development pitfalls;
- verified workarounds or debugging findings useful for future development.

Do not use `Helpers` as a chronological development journal.

A single development task may affect more than one documentation area.
Evaluate each area independently and update only those whose existing
documentation is materially affected.

## Find the Canonical Documentation First

Before editing or creating technical documentation:

1. Determine the appropriate documentation area using the routing rules
   above, then search within that area for the relevant feature, domain,
   or topic.
2. Fetch the strongest matching existing page or pages.
3. Inspect their current structure, terminology, and scope.
4. Identify the canonical page that owns the information.
5. Update that page rather than creating a parallel version.

Do not create pages such as `Coaching APIs v2`, `New Coaching API`, or
`Updated Endpoints` merely because an existing page needs an update.

If no appropriate page or record exists, create new documentation only when
the user's documentation request authorizes it and the correct documentation
area and parent/location can be determined confidently. Otherwise report that
a canonical destination could not be established.

## Already-Accurate Documentation

If the canonical documentation already accurately represents the verified
implementation, do not rewrite it merely to produce a documentation change.

Treat the documentation area as requiring no content update.

When the area was materially evaluated as part of the documentation request,
re-fetch the relevant canonical page or record as needed to confirm that it
is already accurate.

Do not create duplicate documentation or make wording-only edits solely to
turn a no-op into an update.

## Obsolete Documentation

When implementation is removed, deprecated, or replaced, follow the canonical
documentation area's existing convention for representing obsolete behavior.

Do not delete or archive an entire Notion page or record merely because the
implementation it describes was removed.

Prefer updating the canonical documentation so it no longer presents obsolete
behavior as current. Delete, archive, move, or structurally reorganize Notion
content only when explicitly authorized or when the established documentation
workflow clearly requires that operation.

## API Documentation

Apply this section when verified work is routed to `Backend API Tracker` and
the affected documentation concerns an API contract.

When an endpoint is introduced, materially changed, deprecated,
replaced, or removed, synchronize the canonical API documentation with
the verified implementation.

As applicable, document:

- HTTP method;
- route/path;
- purpose;
- authentication/authorization requirements;
- path parameters;
- query parameters;
- request body and field requirements;
- response contract;
- relevant HTTP status codes;
- validation and error behavior;
- cross-service behavior when it is part of the API contract.

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

Apply these rules when durable data-model information belongs to the
canonical documentation being updated.

Update data-model documentation when persisted entities, relationships,
ownership, or important durable constraints change.

Distinguish clearly between:

- persistence entities/models;
- API DTOs/contracts;
- Flutter/client models.

Do not present a DTO field as a database column, or a client model as a
backend persistence model, unless that relationship is verified.

## Architecture and Service Boundaries

Architecture and service-boundary changes do not automatically imply a
separate architecture page.

Update the canonical documentation area that already owns the affected
architectural information. Create separate architecture documentation only
when the existing Pump documentation structure establishes that as the
canonical location or the user explicitly requests it.

Update architecture documentation only for actual architectural changes.

Examples include:

- moving ownership of data between services;
- introducing or removing a cross-service dependency;
- changing authentication/authorization flow;
- introducing a new infrastructure component;
- changing a durable integration or communication pattern;
- changing deployment/runtime architecture.

Do not label ordinary feature implementation as an architecture change.

Respect service ownership defined by the current repository's
`AGENTS.md` and verified implementation.

## Flutter/Backend Synchronization

When both frontend and backend implementations changed and both can be
verified, evaluate `Frontend Tracker` and `Backend API Tracker` independently;
one does not substitute for the other.

When documenting Flutter integration with a backend API, verify both
sides only when both repositories are actually available to inspect.

If only one side is available:

- document what can be verified from that repository;
- use existing authoritative documentation only as supporting context;
- do not claim that the unavailable repository was changed;
- do not add the unavailable repository to the Daily Development Log
  merely because it participates in the integration.

## Preserve Existing Documentation Style

Follow the canonical Notion page's existing:

- terminology;
- heading hierarchy;
- level of detail;
- endpoint grouping;
- table/list conventions;
- formatting style.

Make the smallest coherent update that leaves the page accurate and
understandable.

Do not rewrite unrelated sections merely to improve wording.

Preserve useful existing context that remains correct.

## Verify Documentation Updates

After creating or updating durable Notion documentation:

1. Re-fetch every page or record changed by the documentation operation.
2. Verify that the intended information was written successfully.
3. Verify that unrelated existing information that should have been preserved
   remains intact.
4. Verify that the documentation is in the intended canonical area and that a
   duplicate page or record was not accidentally created.
5. Retrieve the canonical Notion URL from the verified page or record for the
   completion response.

Do not report a documentation update as successful when the final Notion
state cannot be verified.

If the write succeeds but verification is incomplete or unavailable, report
that limitation instead of claiming full verification.

## Conflicts and Uncertainty

If verified current implementation and existing Notion documentation
conflict, update stale Notion documentation when the implementation is clearly
authoritative for the requested documentation task, and mention the
corrected mismatch in the completion summary when material.

If `AGENTS.md`, implementation, tests, or existing documentation
conflict in a way that suggests the implementation itself may be wrong
or incomplete, do not silently rewrite documentation to legitimize the
discrepancy. Surface the conflict for user review.

Do not resolve ambiguous architecture or contract decisions by
assumption.

## Relationship Between Historical and Durable Documentation

Keep historical progress and durable documentation intentionally different.

The `Daily Development Log` records the verified development outcome for a
specific date.

The durable documentation areas describe the current state of the product,
system, release history, or reusable troubleshooting knowledge according to
their individual responsibilities.

Example Daily Development Log entry:

```text
• Added training-block creation API and integrated the Flutter coaching flow.
```

Example API documentation content:

```text
POST /...
Authentication: ...
Request: ...
Response: ...
Validation/errors: ...
```

Do not paste full API specifications, entity schemas, or architecture
explanations into the Daily Development Log.

Conversely, do not turn `Feature Tracker`, `Backend API Tracker`,
`Frontend Tracker`, or `Helpers` into chronological work journals.

`Version / Release Log` may be chronological when that matches its established
Notion structure and convention.

## Helpers Documentation

When work is routed to `Helpers`, follow the `Helpers Documentation Rules`
defined in the main `SKILL.md`.

Before creating a new troubleshooting entry, search for an existing entry
covering the same or a substantially similar problem.

Prefer improving an existing canonical troubleshooting entry over creating a
duplicate.

Keep troubleshooting documentation focused on reusable knowledge: the
problem, relevant context, verified root cause when established, verified
solution or workaround, relevant versions, useful safe commands or
configuration, verification, and meaningful limitations.

Do not copy raw debugging history or investigation noise when a concise
problem-and-solution explanation is sufficient.
