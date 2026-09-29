# Pump Flutter Testing Conventions

## Purpose

This document defines testing and verification conventions for the Pump
Flutter application.

Tests should protect meaningful behavior rather than exist merely to
increase test count.

Apply testing effort according to the behavior changed by the current
task.

Use the repository's existing testing framework, helpers, mocks, fakes,
and patterns.

Do not introduce new testing infrastructure, packages, or broad test
refactors unless explicitly required.

These conventions complement `architecture-conventions.md`,
`coding-conventions.md`, and `ui-conventions.md`.

------------------------------------------------------------------------

## 1. Testing Principles

Tests should provide confidence in observable behavior and important
contracts.

Prioritize tests that protect:

-   critical user workflows;
-   application state transitions;
-   domain/application decisions;
-   data mapping and API integration behavior;
-   validation;
-   error and empty-state distinctions;
-   regressions for fixed defects.

Do not create tests merely to:

-   increase test count;
-   satisfy an arbitrary coverage number;
-   mirror every implementation method;
-   verify third-party framework behavior;
-   lock the code to incidental implementation details.

Prefer a smaller number of meaningful tests over a large number of
low-value tests.

------------------------------------------------------------------------

## 2. Test the Changed Behavior

Testing scope should correspond to the behavior changed by the task.

Prioritize, as applicable:

-   ViewModel state transitions;
-   Use Case behavior;
-   repository/data mapping;
-   API integration behavior;
-   widget behavior;
-   error handling;
-   authentication-related behavior;
-   validation logic;
-   pagination behavior;
-   mutation and refresh behavior;
-   regressions for fixed defects.

Do not create unrelated tests merely because nearby code lacks coverage.

When a change spans multiple layers, choose tests that collectively
protect the changed behavior without duplicating the same assertion at
every layer.

------------------------------------------------------------------------

## 3. Choose the Appropriate Test Boundary

Test behavior at the narrowest boundary that provides meaningful
confidence.

Typical boundaries include:

``` text
Unit test
→ isolated application/data behavior

Widget test
→ observable Flutter UI behavior

Integration test
→ behavior requiring multiple real application boundaries
```

Do not automatically choose an integration test when a unit or widget
test can protect the behavior reliably.

Do not force a unit test when the important behavior is inherently
user-facing and better expressed as a widget test.

Follow existing repository patterns when deciding where dependencies
should be mocked or faked.

------------------------------------------------------------------------

## 4. ViewModel Tests

When ViewModel behavior changes, test meaningful state transitions.

Examples:

``` text
initial
→ loading
→ success
```

``` text
initial
→ loading
→ error
```

Also test relevant behavior such as:

-   valid empty state;
-   retry behavior;
-   mutation success;
-   mutation failure;
-   state refresh;
-   prevention of invalid duplicate operations;
-   preservation of existing state during localized refresh;
-   pagination state when applicable.

Mock or fake dependencies at the appropriate Use Case boundary according
to existing Pump patterns.

Test the state and behavior visible to the screen rather than every
internal method call.

Do not make tests depend unnecessarily on the exact number of internal
state assignments if the observable state contract remains correct.

------------------------------------------------------------------------

## 5. Use Case Tests

Test Use Cases when they contain meaningful behavior beyond simple
delegation.

When Use Cases contain:

-   decisions;
-   validation;
-   transformation;
-   orchestration;
-   coordination between repository operations;

test those behaviors.

Do not create low-value tests solely to prove that a one-line Use Case
calls a repository if Pump does not normally test such delegation.

If a Use Case is intentionally a thin application boundary, its behavior
may already be sufficiently protected by higher-value tests elsewhere.

------------------------------------------------------------------------

## 6. Repository Tests

Repository/data tests should focus on behavior such as:

-   DTO-to-domain mapping;
-   `Result` / `AppError` mapping;
-   transport failure handling;
-   nullability handling;
-   pagination mapping;
-   request construction where meaningful;
-   translation of transport-specific behavior into the domain contract.

Do not test third-party HTTP libraries themselves.

Do not assert transport implementation details that are irrelevant to
the repository contract.

When a repository distinguishes valid absence from failure, test that
distinction explicitly.

------------------------------------------------------------------------

## 7. HTTP Service Tests

Test HTTP service behavior when request or response construction
contains meaningful project-owned logic.

Useful cases may include:

-   endpoint path construction;
-   HTTP method selection;
-   path/query parameters;
-   request-body serialization;
-   response DTO deserialization;
-   handling of transport responses according to established service
    patterns.

Do not write tests merely to prove that the HTTP client library can
perform an HTTP request.

Do not use real production services for normal unit tests.

Authentication/network infrastructure should be mocked or faked
according to existing repository patterns unless the repository has an
explicit integration-test environment.

------------------------------------------------------------------------

## 8. DTO and Mapping Tests

When mapping logic is non-trivial or contract-sensitive, verify:

-   expected fields map correctly;
-   nullable fields behave correctly;
-   enums/status values map correctly;
-   nested resources map correctly;
-   pagination metadata maps correctly where applicable;
-   transport-specific representation does not leak incorrectly into
    domain behavior.

A backend contract change should trigger review of affected DTO and
mapping tests.

For finite backend values such as enums, test unknown or unsupported
values when the established contract/application behavior defines how
they are handled.

Do not invent fallback behavior in a test that is not defined by the
implementation or confirmed contract.

------------------------------------------------------------------------

## 9. Widget Tests

Use widget tests when meaningful UI behavior needs protection.

Good candidates include:

-   conditional rendering;
-   valid empty states;
-   loading states;
-   error states;
-   action visibility;
-   navigation triggers;
-   form validation;
-   disabled/submitting actions;
-   critical screen interactions;
-   state-dependent sections.

Prefer assertions based on observable user-facing behavior.

Do not create brittle widget tests tied unnecessarily to:

-   private widget structure;
-   exact implementation hierarchy;
-   incidental widget counts;
-   styling details unrelated to the behavior under test.

When a shared Pump component such as `CustomButton`, `CustomTextField`,
or `CustomScaffold` already encapsulates behavior, test feature-specific
behavior rather than retesting the shared component in every screen.

------------------------------------------------------------------------

## 10. Navigation Tests

Test navigation when the changed behavior depends on where an action
sends the user or what result is returned.

Useful cases include:

-   successful submission navigates as intended;
-   an action opens the correct screen;
-   navigation is prevented when validation fails;
-   a returned result causes the owning screen to refresh or update
    state when required.

Prefer testing the observable navigation outcome rather than
implementation-specific navigator calls when practical.

Do not add navigation tests for static routes unrelated to the current
change.

------------------------------------------------------------------------

## 11. Form and Validation Tests

Test client-side validation when it contains meaningful product
behavior.

Verify relevant cases such as:

-   required values;
-   accepted input;
-   rejected input;
-   submission blocked while invalid;
-   duplicate submission prevented while loading;
-   backend validation failure presented correctly.

Do not encode backend-only business rules into Flutter tests unless
those rules are intentionally mirrored for user experience.

Backend validation remains authoritative.

A client validation test must not imply that bypassing the UI would make
the backend accept the same input.

------------------------------------------------------------------------

## 12. Regression Tests

When fixing a defect that can reasonably be reproduced in an automated
test, add a regression test where practical.

The test should fail under the defective behavior and pass after the
fix.

Examples include:

-   incorrect route result type;
-   stale state after mutation;
-   incorrect DTO mapping;
-   duplicate submission;
-   missing empty-state handling;
-   duplicated enum/type usage causing an invalid runtime or assignment
    path;
-   incorrect pagination state.

Name and structure the test around the behavior being protected, not
around the historical implementation mistake.

------------------------------------------------------------------------

## 13. API Integration Changes

When integrating or changing an API, verify the affected chain as
appropriate:

``` text
HTTP Service
  ↓
Repository Implementation
  ↓
Domain Repository
  ↓
Use Case
  ↓
ViewModel
  ↓
Screen
```

Not every layer requires its own isolated test.

Choose tests that provide meaningful confidence without duplicating the
same assertion at every layer.

At minimum, consider whether the change affects:

-   request construction;
-   DTO deserialization;
-   DTO-to-domain mapping;
-   result/error mapping;
-   ViewModel state;
-   screen behavior.

Tests must follow the confirmed backend contract.

Do not encode guessed endpoints, fields, enum values, nullability,
status semantics, or business rules merely to make a test pass.

------------------------------------------------------------------------

## 14. Error Testing

Test important failure paths.

Examples:

-   backend validation failure;
-   unauthorized response;
-   forbidden response when represented separately;
-   not found;
-   conflict;
-   network failure;
-   malformed or unexpected response when the existing architecture
    handles it;
-   mapping failure when applicable.

Verify the behavior expected at the layer being tested.

For example, a repository test may verify an `AppError`, while a widget
test may verify the user-facing state produced from that error.

Do not expose technical backend details in widget expectations unless
the product intentionally displays safe backend-provided text.

Do not silently treat arbitrary failures as valid empty state.

------------------------------------------------------------------------

## 15. Empty State vs Error State

When absence is a valid business condition, test it separately from
actual failure.

Example:

``` text
No active Training Block
```

may be a valid UI state if the confirmed API/application contract
defines it that way.

A network failure is not equivalent to no Training Block.

Likewise:

``` text
[]
```

from a successful collection request is not automatically equivalent to
a failed request that produced no usable data.

Tests should preserve these distinctions.

------------------------------------------------------------------------

## 16. Loading and Repeated Actions

Test loading behavior when it affects user interaction or state
correctness.

Relevant cases include:

-   initial loading;
-   localized refresh;
-   pagination loading;
-   mutation submission;
-   prevention of duplicate submissions.

When existing content should remain visible during a secondary
operation, verify that the test does not incorrectly require the whole
screen to become a full-screen loading state.

When duplicate execution would be incorrect, verify that repeated user
action does not produce duplicate application operations.

------------------------------------------------------------------------

## 17. Pagination Tests

When paginated behavior changes, test the relevant pagination contract.

Consider:

-   initial page loading;
-   loading the next page;
-   appending new items without losing existing items;
-   end-of-list behavior;
-   refresh behavior;
-   next-page failure while preserving existing items;
-   prevention of duplicate page requests;
-   pagination metadata or cursor mapping.

Do not invent page numbers, page sizes, cursors, or end-of-list
semantics not defined by the confirmed backend contract.

------------------------------------------------------------------------

## 18. State Refresh and Mutation Tests

When a mutation affects existing screen state, test the intended
reconciliation behavior.

Depending on the feature, verify that successful mutation correctly:

-   updates local ViewModel state;
-   consumes the returned backend resource;
-   invalidates/refetches the appropriate provider;
-   reloads authoritative state;
-   returns a result to the previous screen.

Also verify relevant failure behavior.

Do not require an unnecessary second network request in a test when the
confirmed mutation response already provides sufficient authoritative
data.

Do not leave stale state untested when stale state was a realistic risk
introduced by the change.

------------------------------------------------------------------------

## 19. Optimistic UI Tests

When a feature intentionally uses optimistic UI, test both success and
reconciliation behavior.

Relevant cases include:

``` text
local optimistic update
→ backend success
→ optimistic state remains valid
```

and:

``` text
local optimistic update
→ backend failure
→ local state rolls back or reconciles
→ failure is communicated appropriately
```

Do not test optimistic behavior for a feature that does not
intentionally use it.

The backend remains the source of truth.

------------------------------------------------------------------------

## 20. Authentication-Related Tests

When a Flutter change affects authenticated behavior, test the
application behavior owned by Flutter.

Examples may include:

-   authenticated state changes presentation;
-   unauthenticated state triggers the established application flow;
-   protected actions are not presented when the product design requires
    hiding them.

Do not treat Flutter authorization behavior as a security guarantee.

Do not add tests that imply client-side hiding or state checks replace
backend authorization.

Never use real credentials, JWTs, or secrets in tests.

Use safe fake values when authentication-shaped data is required.

------------------------------------------------------------------------

## 21. Test Naming

Test names should describe observable behavior.

Prefer names such as:

``` text
returns clients when repository succeeds
emits error state when loading clients fails
shows add exercises when training block has no program
hides week selector when no exercises exist
prevents duplicate submission while request is loading
preserves existing clients when loading next page fails
```

Avoid vague names such as:

``` text
test clients
test success
works
test method
```

Follow existing repository naming style when it is more specific.

A test name should explain what behavior failed without requiring the
reader to inspect the implementation first.

------------------------------------------------------------------------

## 22. Test Structure

Keep tests easy to scan.

Follow the repository's established structure.

When useful, organize a test conceptually as:

``` text
Arrange
Act
Assert
```

Do not add comments for `Arrange`, `Act`, and `Assert` mechanically when
the test is already obvious.

Keep setup focused on the behavior being tested.

Extract shared setup when it reduces meaningful duplication without
hiding the important conditions of individual tests.

------------------------------------------------------------------------

## 23. Test Data and Fixtures

Use test data that makes the behavior under test clear.

Prefer explicit builders, fixtures, or helpers already established by
the repository.

Do not depend on production data.

Do not use sensitive or real personal information in fixtures.

Avoid enormous fixtures when only a few fields matter to the behavior.

When a test depends on a specific distinction, make that distinction
obvious in the test data.

Example:

``` dart
final activeClient = Client(
  // fields relevant to the test
);
```

Do not hide all meaningful test conditions behind a generic fixture when
doing so makes the test difficult to understand.

------------------------------------------------------------------------

## 24. Test Isolation

Tests should not depend on execution order.

Reset mutable state between tests.

Each test should establish the state it requires.

Avoid shared mutable fixtures that allow one test to affect another.

Avoid real backend/network dependencies in unit and widget tests unless
the repository already has an explicit integration-test environment for
that purpose.

Use existing mocks, fakes, and test helpers.

Time-dependent behavior should use controllable time/fakes when the
existing test architecture supports it rather than relying on arbitrary
real delays.

------------------------------------------------------------------------

## 25. Deterministic Async Tests

Async tests should be deterministic.

Await the operation whose behavior is under test.

For widget tests, use the appropriate Flutter test utilities to advance
frames and settle expected asynchronous UI work.

Avoid arbitrary delays such as:

``` dart
await Future.delayed(const Duration(seconds: 1));
```

solely to make a test pass.

Do not use `pumpAndSettle()` blindly when the UI contains intentionally
continuous animations or other behavior that may never settle.

Prefer waiting for the specific state or frame progression required by
the behavior.

------------------------------------------------------------------------

## 26. Do Not Over-Mock

Mock external boundaries and dependencies when appropriate.

Do not mock the exact implementation being tested.

Prefer testing observable behavior rather than verifying every internal
method call.

Tests should allow safe internal refactoring where behavior remains
unchanged.

Use a fake instead of a highly configured mock when the fake provides
clearer and more stable behavior according to existing project patterns.

Interaction verification is appropriate when the interaction itself is
the contract, such as preventing a duplicate repository operation.

------------------------------------------------------------------------

## 27. Avoid Brittle Assertions

Assert what matters to the behavior.

Avoid assertions that depend on incidental details such as:

-   private implementation order;
-   unrelated widget counts;
-   exact internal method sequence;
-   formatting that is not part of the requirement;
-   full object equality when only a specific behavior matters and
    equality is not the contract.

Use precise assertions for contract-sensitive values.

For example, DTO/domain mapping tests should verify the fields whose
mapping is part of the contract.

A test should fail because behavior changed incorrectly, not because
harmless internal refactoring occurred.

------------------------------------------------------------------------

## 28. Golden and Snapshot Tests

Do not introduce golden/snapshot testing as an incidental part of a
feature.

Use it only when the repository already has an established golden-test
workflow or when explicitly requested.

If golden tests are used, keep them focused on visual behavior that
genuinely requires image-level regression protection.

Do not use golden tests as a replacement for behavioral widget tests.

------------------------------------------------------------------------

## 29. Integration Tests

Use integration tests when meaningful confidence requires multiple real
application boundaries working together.

Examples may include:

-   a critical end-to-end application flow;
-   behavior that cannot be represented reliably with unit/widget
    boundaries;
-   repository-established integration scenarios.

Do not introduce a new integration-test environment as part of an
unrelated feature.

Do not target production services from automated integration tests
unless the repository has an explicitly approved mechanism for doing so.

Integration tests must not require real user credentials or secrets
committed to the repository.

------------------------------------------------------------------------

## 30. Generated and Third-Party Behavior

Do not write tests for generated code or third-party libraries merely to
prove that those implementations work.

Test Pump-owned behavior that depends on them.

If generated mapping or serialization is driven by Pump-owned
declarations and the resulting contract is important, test the
observable serialization/mapping behavior at the appropriate boundary
rather than the generator implementation itself.

------------------------------------------------------------------------

## 31. Verification Commands

Before completion, run verification appropriate to the changed scope.

Common Flutter verification includes:

``` bash
dart format <modified-paths>
flutter analyze
flutter test
```

Use repository-specific commands when they exist.

For narrowly scoped development, focused tests may be run first.

Example:

``` bash
flutter test test/path/to/affected_test.dart
```

Before claiming a meaningful feature is complete, run the broader
applicable checks when practical.

Do not claim a command was run if it was not actually executed.

------------------------------------------------------------------------

## 32. Static Analysis

Run:

``` bash
flutter analyze
```

for meaningful Flutter changes when the environment permits it.

Do not ignore new warnings or errors introduced by the current task.

Do not fix unrelated pre-existing warnings merely to make the task
appear clean.

Report unrelated pre-existing failures separately.

Do not suppress analyzer findings without a justified reason consistent
with `coding-conventions.md`.

------------------------------------------------------------------------

## 33. Formatting Verification

Run the Dart formatter against modified Dart code.

Prefer:

``` bash
dart format <modified-paths>
```

Do not perform repository-wide formatting unless explicitly requested or
required by the repository workflow.

Formatting-only changes to unrelated files should not be included in a
feature change.

If formatting changes a modified file, review the resulting diff before
completion.

------------------------------------------------------------------------

## 34. Test Failures

If a test or verification command fails:

1.  Determine whether the current change caused the failure.
2.  Fix failures caused by the current task.
3.  Do not silently modify unrelated behavior to make an unrelated test
    pass.
4.  Report pre-existing or unrelated failures clearly.
5.  Report when the environment prevents reliable verification.

Do not claim the suite passes when it does not.

Do not delete, skip, weaken, or broadly relax a valid test merely to
make the current implementation pass.

If an existing test is genuinely obsolete because the intended behavior
changed, update it to the confirmed new behavior and make that reason
clear.

------------------------------------------------------------------------

## 35. Skipped and Disabled Tests

Do not skip or disable a failing test as the default fix.

A skipped test must have a legitimate reason consistent with repository
practices.

Do not leave temporary skipped tests after development without
explicitly reporting them.

If a test cannot currently run because of an external environment
limitation, report that limitation rather than making the test appear
successful.

------------------------------------------------------------------------

## 36. Completion Reporting

When reporting completion, explicitly state the applicable verification
performed.

Include:

-   tests added;
-   tests modified;
-   focused tests run;
-   `flutter analyze` result;
-   `flutter test` result;
-   anything that could not be run;
-   relevant pre-existing failures.

Never state that a command passed unless it was actually executed
successfully.

Distinguish:

``` text
not run
```

from:

``` text
run and passed
```

and:

``` text
run and failed for a pre-existing/unrelated reason
```

------------------------------------------------------------------------

## 37. Test Scope Control

Testing should increase confidence in the requested change without
turning a feature task into an unrelated test-infrastructure project.

When modifying existing tests:

-   update what the changed behavior requires;
-   preserve unrelated coverage;
-   avoid broad fixture rewrites without need;
-   avoid unrelated test renaming or formatting;
-   do not replace the project's testing approach incidentally.

If broader test infrastructure would be valuable but is outside the
current scope, recommend it separately rather than silently introducing
it.

------------------------------------------------------------------------

## 38. Testing Verification Checklist

Before completing a meaningful Flutter change, verify that:

-   changed behavior has appropriate test coverage where practical;
-   valid empty states are not treated as failures;
-   important failure paths are protected;
-   API tests follow confirmed contracts rather than assumptions;
-   mutation/refresh behavior does not leave stale state;
-   pagination behavior is tested when affected;
-   duplicate submissions or requests are protected when relevant;
-   tests do not depend on execution order;
-   async tests do not rely on arbitrary delays;
-   mocks/fakes are placed at appropriate boundaries;
-   tests assert behavior rather than incidental implementation details;
-   no real secrets or credentials are used;
-   modified Dart files were formatted;
-   `flutter analyze` was run when applicable and possible;
-   relevant tests were run;
-   verification results are reported accurately.

Architecture and layer ownership are governed by
`architecture-conventions.md`.

Coding structure and implementation style are governed by
`coding-conventions.md`.

UI behavior and presentation conventions are governed by
`ui-conventions.md`.
