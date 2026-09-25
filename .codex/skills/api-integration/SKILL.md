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
   - `docs/conventions/ARCHITECTURE_CONVENTIONS.md`
   - `docs/conventions/CODING_CONVENTIONS.md`
   - `docs/conventions/UI_CONVENTIONS.md`
   - `docs/conventions/TESTING_CONVENTIONS.md`
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
   - HTTP method
   - endpoint path
   - authentication requirement
   - path/query parameters
   - request body
   - response body
   - response envelope
   - success status codes
   - relevant error behavior
   - pagination behavior, if applicable
   - media/content type, if applicable
4. Inspect the nearest equivalent Flutter implementation.
5. Trace the existing feature layers.
6. Identify the screen that owns the new behavior.
7. Reuse existing DTOs, domain models, repositories, providers, Use Cases,
   ViewModels, and services where appropriate.
8. Determine the minimum set of files/layers that actually need to change.

If the backend contract cannot be verified, do not guess it.

State what contract information is missing.

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
