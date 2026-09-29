# Pump Flutter Architecture Conventions

## Purpose

This document defines the architectural conventions for the Pump Flutter
application.

Apply these rules to new architecture and to code directly modified
within the scope of the current task.

Do not perform unrelated repository-wide refactors merely to make older
code conform.

When implementation details conflict with this document, first verify
whether the existing implementation represents an intentional newer
convention or legacy code. Do not silently introduce a competing
architecture.

------------------------------------------------------------------------

## 1. Primary Architecture

Pump follows an MVVM-oriented architecture using Riverpod.

The standard API-backed feature flow is:

``` text
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
```

Not every local UI interaction requires every layer.

Use the full flow when the responsibility requires it, especially for
backend operations and domain/data boundaries.

Do not introduce alternative architectural patterns without explicit
justification.

------------------------------------------------------------------------

## 2. Layer Responsibilities

Keep responsibilities at their established boundaries.

### Presentation

Presentation contains screens, screen-owned widgets, ViewModels, and
presentation state.

It may:

-   render domain/application data;
-   collect user input;
-   invoke screen actions through the ViewModel;
-   react to ViewModel state;
-   perform presentation-only transformation when appropriate.

It must not:

-   perform raw HTTP requests;
-   deserialize API responses;
-   depend on transport DTO implementation details when a domain model
    exists;
-   implement authoritative backend business or authorization rules.

### Domain

The domain layer contains application actions and contracts such as:

-   Use Cases;
-   domain models;
-   domain repository abstractions.

The domain layer must remain independent of Flutter widgets and
transport-specific HTTP implementation.

### Data

The data layer contains transport and persistence integration such as:

-   repository implementations;
-   API DTOs;
-   HTTP services;
-   DTO/domain mapping.

Transport-specific concerns must not leak unnecessarily into
presentation or domain code.

------------------------------------------------------------------------

## 3. Screen-Oriented ViewModels

ViewModels are owned by screens.

A ViewModel represents the behavior and presentation state required by
the screen that consumes it.

Example:

``` text
ClientsScreen
  ↓
ClientsViewModel
  ↓
GetClientsUseCase
```

If `ClientInfoScreen` retrieves a Training Block:

``` text
ClientInfoScreen
  ↓
ClientInfoViewModel
  ↓
GetTrainingBlockUseCase
```

Do not create:

``` text
TrainingBlockViewModel
```

merely because the API resource is `Training Block`.

Presentation ownership follows the consuming screen.

Domain and data organization may follow the backend resource or domain
concept.

------------------------------------------------------------------------

## 4. One ViewModel Per Screen

As the default Pump convention, each meaningful screen has a
corresponding ViewModel when the screen contains application state or
behavior.

Examples:

``` text
ClientsScreen
→ ClientsViewModel

ClientInfoScreen
→ ClientInfoViewModel

CreateTrainingBlockScreen
→ CreateTrainingBlockViewModel

AddExercisesScreen
→ AddExercisesViewModel
```

Do not create ViewModels based on:

-   API endpoints;
-   DTOs;
-   entities;
-   repositories;
-   individual Use Cases.

A screen may consume multiple Use Cases through the same ViewModel.

Example:

``` text
ClientInfoViewModel
├── GetClientUseCase
├── GetTrainingBlockUseCase
└── other actions genuinely owned by ClientInfoScreen
```

A purely presentational screen or small local interaction does not
require a ViewModel solely to satisfy a naming rule. Add a ViewModel
when the screen owns application state, asynchronous behavior, domain
actions, or other meaningful presentation logic.

Do not share a screen ViewModel across unrelated screens merely to avoid
creating the correct owner.

------------------------------------------------------------------------

## 5. ViewModel Responsibilities

A ViewModel may own:

-   screen presentation state;
-   loading state;
-   empty state;
-   error state;
-   screen-specific data;
-   form state where appropriate;
-   invoking Use Cases;
-   translating application results into presentation state;
-   coordinating multiple actions genuinely owned by the screen;
-   refresh behavior after mutations.

A ViewModel should not:

-   perform raw HTTP calls;
-   parse HTTP responses directly;
-   depend directly on API DTO implementation details;
-   contain backend authorization logic;
-   contain widget-building logic;
-   hold `BuildContext` as application state;
-   become a general-purpose service shared by unrelated screens.

Keep navigation, dialogs, SnackBars, and other UI effects in the
presentation boundary. A ViewModel may expose state or outcomes that
cause those effects, but should not become coupled to Flutter UI
primitives unnecessarily.

------------------------------------------------------------------------

## 6. Presentation State Ownership

State should have one clear owner.

Prefer screen-scoped state when the data or behavior exists only for
that screen.

Promote state to a broader provider only when multiple consumers
genuinely require shared ownership or when its lifecycle must outlive a
single screen.

Do not create global providers merely for convenience.

Avoid maintaining multiple mutable copies of the same authoritative
state across screens or providers.

When state is passed to another screen, deliberately determine whether
the target screen:

-   can safely use the passed value;
-   requires its own authoritative refresh;
-   should own subsequent mutations independently.

------------------------------------------------------------------------

## 7. Riverpod Usage

Use Riverpod according to existing repository patterns.

General ownership:

`ref.watch`

-   reactive rendering.

`ref.read`

-   commands and actions.

`ref.listen`

-   one-time presentation effects when appropriate.

Examples of one-time effects include:

-   navigation after successful submission;
-   SnackBar presentation;
-   error notification.

Screens should use the repository's established provider and ViewModel
patterns rather than introducing a second dependency-injection or
state-management mechanism.

Avoid unnecessary global state.

State should remain scoped to the lifecycle and responsibility that owns
it.

Do not introduce another state-management framework.

------------------------------------------------------------------------

## 8. Use Cases

Use Cases represent meaningful application actions.

Examples:

``` text
GetClientsUseCase
GetTrainingBlockUseCase
CreateTrainingBlockUseCase
EnrollClientUseCase
```

A Use Case should represent an action rather than a generic domain
container.

Use Cases depend on domain repository abstractions rather than concrete
HTTP services or repository implementations.

A Use Case may contain application-level validation, decisions,
transformation, or orchestration when that behavior belongs to the
action.

Do not move transport concerns into a Use Case merely to avoid adding
behavior to the data layer.

Simple delegation is acceptable when the Use Case preserves the
established application boundary and keeps the ViewModel independent of
repository details.

------------------------------------------------------------------------

## 9. Repository Boundary

Domain repositories define the application's data/domain contract.

Example:

``` text
TrainingBlockRepository
```

The domain layer should not depend on:

-   Dio or another HTTP client;
-   HTTP response structures;
-   API DTO implementations;
-   Flutter widgets.

Repository implementations belong to the data layer and implement the
domain repository contract.

Example:

``` text
TrainingBlockRepository
        ↑
TrainingBlockRepositoryImpl
```

Repository implementations may depend on HTTP services, DTOs, mappers,
and other data-layer concerns.

Repository implementations are responsible for translating
transport/data results into the domain contract expected by the
application.

Do not expose transport-specific failures or response wrappers beyond
the established repository boundary when the Pump error/result
architecture already defines the appropriate application representation.

------------------------------------------------------------------------

## 10. DTO and Domain Separation

API DTOs belong to the data layer.

Domain models belong to the domain/application model.

Do not expose API DTOs directly throughout presentation code merely
because their fields currently match the UI.

Typical mapping:

``` text
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
```

Mapping should occur at the appropriate data/repository boundary
according to existing repository patterns.

Do not make domain models depend on DTOs.

Do not create duplicate domain models when an existing model already
represents the same concept adequately.

When an API contract changes, review both DTO mapping and the affected
domain model instead of automatically mirroring every transport field
into presentation.

------------------------------------------------------------------------

## 11. HTTP Services

HTTP/API services own transport concerns such as:

-   endpoint invocation;
-   HTTP methods;
-   path/query parameters;
-   request serialization;
-   response deserialization;
-   transport-level behavior.

HTTP services should not own:

-   screen state;
-   navigation;
-   presentation decisions;
-   authoritative client-side business policy.

Screens and ViewModels must not perform direct HTTP requests when the
established repository architecture applies.

Use the application's established network client and configuration
rather than creating feature-specific HTTP clients without a justified
requirement.

------------------------------------------------------------------------

## 12. Authentication and Authorization Boundary

JWT/authentication handling belongs to the established
authentication/network boundary.

Do not manually duplicate token retrieval or authorization headers
throughout individual screens, ViewModels, Use Cases, or feature
services.

Never treat Flutter state as authoritative authorization.

The backend remains responsible for authorization and access-control
decisions.

Flutter may use authenticated-user state to determine presentation
behavior, but hiding an action in the UI is not a security boundary.

Do not place secrets, long-lived credentials, or backend-only
authorization material in client code.

------------------------------------------------------------------------

## 13. Result and Error Flow

Follow the existing Pump result/error architecture.

When the repository uses:

``` dart
Result<T, AppError>
```

preserve that contract.

Do not introduce competing result wrappers for individual features.

Errors should propagate through the established layers without silently
being converted into successful or default states.

Preserve the distinction between:

-   successful data;
-   valid empty/absent business state;
-   validation failure;
-   authentication/authorization failure;
-   not found;
-   conflict;
-   transport/network failure;
-   unexpected application failure.

Presentation decides how an application error should be shown to the
user.

Do not expose transport or backend implementation details directly to
the UI when an established application error representation exists.

------------------------------------------------------------------------

## 14. API Contracts

The backend implementation or a confirmed API contract defines what the
API does.

Flutter defines how that contract is integrated and presented.

Do not invent:

-   endpoint paths;
-   HTTP methods;
-   request fields;
-   response fields;
-   enum values;
-   pagination behavior;
-   authentication behavior;
-   nullability semantics;
-   status-code meaning;
-   business rules.

When backend context is unavailable and materially affects
implementation, identify the missing contract instead of guessing.

When integrating an API, verify the contract against the relevant
backend implementation or authoritative project documentation when that
context is available.

Keep request DTOs, response DTOs, domain models, and UI state distinct
when their responsibilities differ.

------------------------------------------------------------------------

## 15. Backend Service Ownership

Pump backend domains have explicit ownership:

``` text
pump-auth-service
→ authentication and account identity

pump-social-service
→ social-domain functionality

pump-coaching-service
→ coaching-domain functionality
```

Flutter consumes these domains through APIs.

Never:

-   access backend databases directly;
-   duplicate authoritative backend rules in Flutter;
-   move domain ownership into Flutter because the UI needs the data;
-   treat one backend service as the owner of another service's domain
    merely for client convenience.

Client-side validation may improve UX but does not replace backend
validation.

When a feature crosses backend domains, preserve each service's
ownership rather than inventing a client-side source of truth.

------------------------------------------------------------------------

## 16. Navigation and Data Passing

Follow the repository's established navigation implementation.

When navigating:

-   pass already available data when it is sufficient;
-   avoid redundant API calls merely to retrieve data the caller already
    owns;
-   fetch fresh data when authoritative/current information is required;
-   keep route arguments explicit and type-safe;
-   deliberately handle results returned from child screens when they
    affect the caller.

Do not introduce another navigation framework without explicit approval.

Do not use navigation as an implicit state-management mechanism when
state ownership should be explicit.

------------------------------------------------------------------------

## 17. State Refresh and Stale Data

Avoid stale state after mutations.

After successful create, update, or delete operations, deliberately
determine whether to:

-   update local ViewModel state;
-   invalidate or refetch a provider;
-   reload the owning screen;
-   consume the returned backend resource;
-   propagate a result to the previous screen.

Do not automatically issue duplicate network requests if the confirmed
response already contains sufficient authoritative data.

Do not assume locally mutated state remains authoritative when the
backend may apply additional transformations or business rules.

Choose the smallest refresh strategy that restores correct authoritative
state without unnecessary requests.

------------------------------------------------------------------------

## 18. Pagination and Collection Ownership

When an API is paginated, preserve the confirmed backend pagination
contract.

Keep pagination orchestration in the appropriate ViewModel/application
flow rather than embedding backend paging behavior directly in widgets.

Track pagination state deliberately, including applicable concepts such
as:

-   current page or cursor;
-   whether more data is available;
-   initial loading;
-   loading additional data;
-   refresh;
-   pagination failure.

Do not discard already valid collection data merely because loading the
next page fails.

Do not invent page sizes, cursor semantics, or end-of-list behavior that
are not defined by the backend contract.

------------------------------------------------------------------------

## 19. Forms and Mutation Flow

For API-backed forms, keep responsibilities separated.

Typical flow:

``` text
Screen / Form Widgets
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
```

The screen owns input widgets and presentation concerns.

The ViewModel may own submission state and screen-level form/application
state.

Use Cases and domain/data layers own application and integration
behavior according to their established responsibilities.

Client-side validation may reject obviously invalid input for UX, but
backend validation remains authoritative.

Prevent duplicate mutation requests when repeated submission would be
incorrect.

After a mutation succeeds, deliberately reconcile the resulting state
according to the refresh rules in this document.

------------------------------------------------------------------------

## 20. Dependency Direction

Dependencies should point inward toward stable application contracts.

The expected direction is:

``` text
Presentation
    ↓
Domain / Application
    ↑
Data implementations
```

More concretely:

``` text
Screen / ViewModel
        ↓
     Use Case
        ↓
Domain Repository
        ↑
Repository Implementation
        ↓
   HTTP Service
```

The domain layer must not import presentation or transport
implementation details.

The data layer may implement domain contracts.

Presentation may depend on domain/application abstractions and
established provider wiring.

Avoid circular dependencies between feature layers.

------------------------------------------------------------------------

## 21. Provider and Dependency Wiring

Provider definitions should wire existing architectural dependencies
rather than contain unrelated business behavior.

Typical dependency construction follows the established chain:

``` text
HTTP Service
  ↓
Repository Implementation
  ↓
Use Case
  ↓
Screen ViewModel
```

Keep provider ownership and lifecycle consistent with nearby Pump
features.

Do not instantiate repositories, Use Cases, or HTTP services directly
inside screen build methods.

Do not create duplicate providers for the same dependency merely because
another screen needs access to it. Reuse the established dependency
provider while keeping screen ViewModel ownership separate.

------------------------------------------------------------------------

## 22. Cross-Repository Changes

If a Flutter change requires a backend contract change:

1.  Identify the backend requirement.
2.  Do not simulate the missing behavior in Flutter.
3.  Preserve backend service ownership.
4.  Consider compatibility with existing consumers.
5.  Coordinate DTO/domain changes.
6.  Consider deployment order for breaking changes.

Prefer additive, backward-compatible contracts when practical.

Do not claim a cross-repository contract is implemented until the
relevant repository evidence confirms it.

When only the Flutter repository is in scope, clearly identify required
backend work rather than fabricating or assuming it.

------------------------------------------------------------------------

## 23. Architecture Changes

Do not introduce a new:

-   state-management framework;
-   repository architecture;
-   dependency-injection framework;
-   navigation architecture;
-   networking architecture;
-   application architecture.

as an incidental part of feature development.

Material architectural changes require explicit discussion of their
tradeoffs.

Before introducing a new architectural abstraction, verify that an
existing Pump abstraction does not already solve the requirement.

Prefer extending established architecture over creating a parallel
implementation.

------------------------------------------------------------------------

## 24. Scope and Legacy Code

These conventions apply to new code and code directly affected by the
current task.

Existing code may predate these conventions.

When touching legacy code:

-   bring directly affected code into compliance when safe and relevant;
-   preserve behavior outside the requested scope;
-   avoid repository-wide migrations without explicit approval;
-   do not copy a legacy pattern into new code merely because it already
    exists;
-   do not rewrite unrelated legacy code solely to satisfy this
    document.

If an existing implementation materially conflicts with these
conventions and changing it is necessary for the task, identify the
conflict and choose the smallest safe architectural correction.

------------------------------------------------------------------------

## 25. Architecture Verification

Before completing a meaningful architectural or API-integration change,
verify the affected flow.

Depending on scope, inspect the relevant chain:

``` text
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
```

Confirm that:

-   responsibilities remain in the correct layer;
-   dependency direction is preserved;
-   API contracts were not invented;
-   DTOs do not leak unnecessarily into presentation;
-   authentication and authorization boundaries remain intact;
-   state ownership is clear;
-   mutation/refresh behavior does not leave stale state;
-   no competing architecture was introduced.

Testing and command-level verification are governed by
`testing-conventions.md`.

Coding-level structure and naming are governed by
`coding-conventions.md`.

UI and presentation styling are governed by `ui-conventions.md`.
