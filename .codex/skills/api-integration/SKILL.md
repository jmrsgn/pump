---
name: api-integration
description: "Integrate a Pump mobile backend API using the repository's established Service, Repository, DTO/domain, Use Case, Riverpod ViewModel, and screen architecture. Use when adding or modifying a real HTTP-backed capability; do not use for presentation-only work."
---

# Pump API Integration

Integrate backend API capabilities by extending the nearest existing Pump
feature pattern.

The backend implementation or confirmed API contract is authoritative for
what the API does.

The existing Flutter repository and its required convention documents are
authoritative for how that contract is integrated into Pump.

Do not infer backend behavior from UI requirements.

Do not introduce a new application architecture as part of an API integration.

---

# Required Repository Instructions

Before implementing an API integration:

1. Read the repository `AGENTS.md`.
2. Read:
   - `docs/conventions/architecture-conventions.md`
   - `docs/conventions/coding-conventions.md`
   - `docs/conventions/ui-conventions.md`
   - `docs/conventions/testing-conventions.md`
3. Inspect the relevant existing Flutter implementation.
4. Inspect the backend endpoint or another authoritative API contract.

These repository convention files define the mandatory architecture, coding,
UI, and testing rules.

This Skill defines the workflow for integrating an API.

Do not duplicate or override those conventions here.

---

# Before Implementation

Before creating or modifying files:

1. Identify the backend service that owns the capability.
2. Inspect the backend endpoint or confirmed API contract.
3. Confirm:
   - HTTP method;
   - endpoint path;
   - authentication and authorization requirements;
   - path and query parameters;
   - request body;
   - response body;
   - response envelope;
   - success status codes;
   - relevant error behavior;
   - nullability and optional fields;
   - enum values or other constrained values;
   - pagination behavior, if applicable;
   - media/content type, if applicable.
4. Inspect the nearest equivalent Flutter implementation.
5. Trace the existing feature layers and dependency wiring.
6. Identify the screen that owns the new behavior.
7. Search for and reuse existing DTOs, domain models, repositories, providers,
   Use Cases, ViewModels, services, enums, and shared types where appropriate.
8. Determine the minimum set of files and layers that actually need to change.

If the backend contract cannot be verified, do not guess it.

State what contract information is missing and stop the affected integration
work until the contract can be established.

---

# Established API Flow

For implemented Auth, Social, and Coaching APIs, the normal API-backed flow is:

```text
Consumer Screen
    ↓
Screen ViewModel
    ↓
Use Case
    ↓
Domain Repository
    ↓
Data Repository Implementation
    ↓
HTTP Service
    ↓
Backend
```

Follow the complete flow when the capability requires those layers.

Do not create a layer solely to satisfy the diagram when the repository's
existing architecture and conventions do not require it for the behavior
being integrated.

Do not bypass an established layer for convenience.

---

# Integration Workflow

Implement from the backend boundary toward the consuming screen while
preserving the repository's established dependency direction.

## 1. Contract and Models

Represent the verified backend contract using the repository's existing DTO
and domain-model patterns.

Add or modify only the request DTOs, response DTOs, domain models, enums, and
mappings required by the verified contract.

Preserve the distinction between transport models and domain models according
to the architecture conventions.

Do not invent fields, defaults, enum values, nullability, or client-side
business rules that are not supported by the backend contract.

## 2. HTTP Service

Add or modify the HTTP service operation using the repository's established
HTTP client, authentication, headers, serialization, error handling, and
service conventions.

The service operation must reflect the verified HTTP method, route,
parameters, request body, response contract, and content type.

Do not introduce a separate HTTP client or networking pattern when the
repository already provides one.

## 3. Repository

Expose the capability through the appropriate domain repository and implement
it in the corresponding data repository.

Keep transport-specific DTO handling and mapping on the data side of the
repository boundary.

Preserve the repository's established `Result<T, AppError>` and error
translation behavior.

## 4. Use Case

Add or modify the Use Case that represents the application action required by
the consuming feature.

Reuse an existing Use Case when it already represents the required behavior.

Do not create Use Cases based merely on endpoint names or HTTP verbs.

## 5. ViewModel and State

Integrate the Use Case into the ViewModel owned by the consuming screen.

Update screen state according to the established Riverpod and presentation
state conventions.

Handle relevant loading, success, empty, and error states without moving
backend business rules into the ViewModel.

Prevent duplicate or conflicting requests where required by the existing
interaction pattern.

## 6. Screen Integration

Connect the screen to the ViewModel using the established Riverpod access
patterns.

Preserve the existing Pump UI and shared components.

The screen should initiate user actions and render state; it should not call
HTTP services, repository implementations, or backend APIs directly.

Handle navigation results, refresh behavior, optimistic updates, pagination,
or other interaction behavior only when required by the capability being
integrated.

---

# Existing Capability Changes

When modifying an already integrated API:

1. Trace the existing API flow before editing it.
2. Compare the existing Flutter contract with the verified backend contract.
3. Update only the affected layers.
4. Preserve compatible existing behavior where the backend contract has not
   changed.
5. Update mappings, state handling, tests, and consumers affected by the
   contract change.

Do not rebuild an existing integration from scratch merely because a different
structure would be possible.

---

# Cross-Repository Contract Verification

When the authoritative backend implementation is available in another Pump
repository, use it to verify the API contract before implementing the Flutter
integration.

Respect backend service ownership:

- Auth capabilities belong to `pump-auth-service`;
- Social capabilities belong to `pump-social-service`;
- Coaching capabilities belong to `pump-coaching-service`.

The Flutter application consumes these contracts. It does not redefine them.

If the backend implementation and existing Flutter assumptions disagree,
surface the mismatch and use the verified backend contract as the API source
of truth unless an explicit compatibility requirement says otherwise.

---

# Testing and Verification

Test the integration according to `testing-conventions.md`.

Add or update tests for the behavior materially changed by the integration at
the appropriate layers.

At minimum, verify the affected code with the repository's required formatting,
static-analysis, and testing commands.

Do not claim that an integration, test, or verification passed unless the
corresponding command or behavior was actually executed and succeeded.

If verification cannot be completed, report what was not verified and why.

---

# Scope Control

Keep API integration changes limited to the capability being implemented.

Do not use API integration work as justification for unrelated:

- architecture changes;
- UI redesigns;
- state-management migrations;
- repository-wide refactors;
- naming cleanups;
- dependency changes;
- backend changes outside the verified capability.

If an unrelated issue is discovered, report it separately rather than
expanding the integration scope.

---

# Completion

Before considering the API integration complete:

1. Confirm the implemented client contract matches the verified backend
   contract.
2. Confirm the required architectural flow is connected end to end.
3. Confirm dependency/provider wiring is complete.
4. Confirm the consuming screen uses the intended ViewModel behavior.
5. Confirm relevant loading, success, empty, and error behavior.
6. Confirm required tests and repository verification were executed.
7. Review the final diff for accidental or unrelated changes.

Report:

- the API capability integrated;
- the backend contract used as the source of truth;
- the significant Flutter layers changed;
- tests and verification actually executed;
- any remaining contract uncertainty, blocker, or unverified behavior.