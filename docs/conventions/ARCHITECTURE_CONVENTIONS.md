# Pump Flutter Architecture Conventions

## Purpose

This document defines the architectural conventions for the Pump Flutter
application.

These rules apply to new architecture and to code modified within the scope of
the current task.

Do not perform unrelated repository-wide refactors merely to make older code
conform.

---

# 1. Primary Architecture

Pump follows an MVVM-oriented architecture using Riverpod.

The standard API-backed feature flow is:

Screen
↓
Screen ViewModel
↓
Use Case
↓
Domain Repository
↓
Repository Implementation
↓
HTTP Service
↓
Backend API

Not every local UI interaction requires every layer.

Use the full flow when the responsibility requires it, especially for backend
operations and domain/data boundaries.

Do not introduce alternative architectural patterns without explicit
justification.

---

# 2. Screen-Oriented ViewModels

ViewModels are owned by screens.

The ViewModel should represent the behavior and presentation state required by
the screen that consumes it.

Example:

ClientsScreen
↓
ClientsViewModel
↓
GetClientsUseCase

If ClientInfoScreen retrieves a Training Block:

ClientInfoScreen
↓
ClientInfoViewModel
↓
GetTrainingBlockUseCase

Do NOT create:

TrainingBlockViewModel

merely because the API resource is Training Block.

Presentation ownership follows the consuming screen.

Domain/data organization may follow the backend resource.

---

# 3. One ViewModel Per Screen

As the default Pump convention, each meaningful screen has a corresponding
ViewModel when the screen contains application state or behavior.

Examples:

ClientsScreen
→ ClientsViewModel

ClientInfoScreen
→ ClientInfoViewModel

CreateTrainingBlockScreen
→ CreateTrainingBlockViewModel

AddExercisesScreen
→ AddExercisesViewModel

Do not create ViewModels based on:

- API endpoints
- DTOs
- entities
- repositories
- individual Use Cases

A screen may consume multiple Use Cases through the same ViewModel.

Example:

ClientInfoViewModel
├── GetClientUseCase
├── GetTrainingBlockUseCase
└── other actions genuinely owned by ClientInfoScreen

---

# 4. ViewModel Responsibilities

A ViewModel may own:

- screen presentation state
- loading state
- empty state
- error state
- screen-specific data
- form state where appropriate
- invoking Use Cases
- translating application results into presentation state

A ViewModel should not:

- perform raw HTTP calls
- parse HTTP responses directly
- depend directly on API DTO implementation details
- contain backend authorization logic
- become a general-purpose service shared by unrelated screens

---

# 5. Riverpod Usage

Use Riverpod according to existing repository patterns.

General ownership:

`ref.watch`

- reactive rendering

`ref.read`

- commands/actions

`ref.listen`

- one-time presentation effects when appropriate

Examples of one-time effects:

- navigation after successful submission
- SnackBar presentation
- error notification

Avoid unnecessary global state.

State should remain scoped to the lifecycle and responsibility that owns it.

Do not introduce another state-management framework.

---

# 6. Use Cases

Use Cases represent application actions.

Examples:

GetClientsUseCase
GetTrainingBlockUseCase
CreateTrainingBlockUseCase
EnrollClientUseCase

A Use Case should represent a meaningful action rather than a generic domain
container.

Use Cases depend on domain repository abstractions rather than concrete HTTP
services.

---

# 7. Repository Boundary

Domain repositories define the application's data/domain contract.

Example:

TrainingBlockRepository

The domain layer should not depend on:

- Dio
- HTTP response structures
- API DTO implementation
- Flutter widgets

Repository implementations belong to the data layer and implement the domain
repository contract.

Example:

TrainingBlockRepository
↑
TrainingBlockRepositoryImpl

Repository implementations may depend on HTTP services and DTOs.

---

# 8. DTO and Domain Separation

API DTOs belong to the data layer.

Domain models belong to the domain/application model.

Do not expose API DTOs directly throughout presentation code merely because
their fields currently match the UI.

Typical mapping:

HTTP response
↓
DTO
↓
Repository Implementation
↓
Domain Model
↓
Use Case
↓
ViewModel
↓
Screen

Mapping should occur at the appropriate data/repository boundary according to
existing repository patterns.

Do not make domain models depend on DTOs.

---

# 9. HTTP Services

HTTP/API services own transport concerns such as:

- endpoint invocation
- HTTP methods
- request serialization
- response deserialization
- transport-level behavior

HTTP services should not own screen state.

Screens and ViewModels must not perform direct HTTP requests when the
established repository architecture applies.

---

# 10. Authentication Boundary

JWT/authentication handling belongs to the established authentication/network
boundary.

Do not manually duplicate token retrieval or authorization headers throughout
individual screens or ViewModels.

Never treat Flutter state as authoritative authorization.

Backend services remain responsible for authorization.

---

# 11. Result and Error Flow

Follow the existing Pump result/error architecture.

When the repository uses:

Result<T, AppError>

preserve that contract.

Do not introduce competing result wrappers for individual features.

Errors should propagate through the established layers without silently being
converted into successful/default states.

Presentation decides how an application error should be shown to the user.

---

# 12. API Contracts

The backend implementation or confirmed API contract defines what the API
does.

Flutter defines how that contract is integrated.

Do not invent:

- endpoint paths
- HTTP methods
- request fields
- response fields
- enum values
- pagination behavior
- authentication behavior
- nullability semantics
- business rules

When backend context is unavailable and materially affects implementation,
identify the missing contract instead of guessing.

---

# 13. Backend Service Ownership

Auth owns authentication and account identity.

Social owns social-domain functionality.

Coaching owns coaching-domain functionality.

Flutter consumes these domains through APIs.

Never:

- access backend databases directly
- duplicate authoritative backend rules in Flutter
- move domain ownership into Flutter because the UI needs the data

Client-side validation may improve UX but does not replace backend validation.

---

# 14. Navigation and Data Passing

Follow the repository's established navigation implementation.

When navigating:

- pass already available data when it is sufficient
- avoid redundant API calls merely to retrieve data the caller already owns
- fetch fresh data when authoritative/current information is required
- keep route arguments explicit and type-safe

Do not introduce another navigation framework without explicit approval.

---

# 15. State Refresh and Stale Data

Avoid stale state after mutations.

After successful create/update/delete operations, deliberately determine
whether to:

- update local ViewModel state
- invalidate/refetch a provider
- reload the owning screen
- consume the returned backend resource

Do not automatically issue duplicate network requests if the confirmed
response already contains sufficient authoritative data.

---

# 16. Cross-Repository Changes

If a Flutter change requires a backend contract change:

1. Identify the backend requirement.
2. Do not simulate the missing behavior in Flutter.
3. Preserve backend service ownership.
4. Consider compatibility with existing consumers.
5. Coordinate DTO/domain changes.
6. Consider deployment order for breaking changes.

Prefer additive, backward-compatible contracts when practical.

---

# 17. Architecture Changes

Do not introduce a new:

- state-management framework
- repository architecture
- dependency-injection framework
- navigation architecture
- networking architecture
- application architecture

as an incidental part of feature development.

Material architectural changes require explicit discussion of their tradeoffs.
