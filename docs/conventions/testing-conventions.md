# Pump Flutter Testing Conventions

## Purpose

This document defines testing and verification conventions for the Pump Flutter
application.

Tests should protect meaningful behavior rather than exist merely to increase
test count.

Use the repository's existing testing framework and patterns.

Do not introduce new testing infrastructure unless explicitly required.

---

# 1. Test the Changed Behavior

Testing scope should correspond to the behavior changed by the task.

Prioritize:

- critical user workflows
- ViewModel state transitions
- Use Case behavior
- repository/data mapping
- API integration behavior
- error handling
- authentication-related behavior
- validation logic
- regressions for fixed defects

Do not create unrelated tests merely because nearby code lacks coverage.

---

# 2. ViewModel Tests

When ViewModel behavior changes, test meaningful state transitions.

Examples:

initial
→ loading
→ success

initial
→ loading
→ error

Also test relevant behavior such as:

- empty state
- retry behavior
- mutation success
- mutation failure
- state refresh
- prevention of invalid duplicate operations

Mock/fake dependencies at the appropriate Use Case boundary according to
existing project patterns.

---

# 3. Use Case Tests

Test Use Cases when they contain meaningful behavior beyond simple delegation.

Do not create low-value tests solely to prove that a one-line Use Case calls a
repository if the repository convention does not normally test such delegation.

When Use Cases contain decisions, validation, transformation, or orchestration,
test those behaviors.

---

# 4. Repository Tests

Repository/data tests should focus on behavior such as:

- DTO → domain mapping
- Result/AppError mapping
- transport failure handling
- nullability handling
- pagination mapping
- request construction where meaningful

Do not test third-party HTTP libraries themselves.

---

# 5. DTO Mapping Tests

When mapping logic is non-trivial or contract-sensitive, verify:

- expected fields map correctly
- nullable fields behave correctly
- enums/status values map correctly
- nested resources map correctly
- pagination metadata maps correctly where applicable

A backend contract change should trigger review of affected mapping tests.

---

# 6. Widget Tests

Use widget tests when meaningful UI behavior needs protection.

Good candidates include:

- conditional rendering
- empty states
- loading states
- error states
- action visibility
- navigation triggers
- form validation
- critical screen interactions

Do not create brittle tests tied unnecessarily to implementation details.

Prefer observable user-facing behavior.

---

# 7. Regression Tests

When fixing a defect that can reasonably be reproduced in an automated test,
add a regression test where practical.

The test should fail under the defective behavior and pass after the fix.

Examples include:

- incorrect route result type
- stale state after mutation
- incorrect DTO mapping
- duplicate submission
- missing empty-state handling

---

# 8. API Integration Changes

When integrating or changing an API, verify the affected chain as appropriate:

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

Not every layer requires its own isolated test.

Choose tests that provide meaningful confidence without duplicating the same
assertion at every layer.

---

# 9. Error Testing

Test important failure paths.

Examples:

- backend validation failure
- unauthorized response
- not found
- conflict
- network failure
- malformed/unexpected response when the existing architecture handles it

Do not silently treat arbitrary failures as valid empty state.

---

# 10. Empty State vs Error State

When absence is a valid business condition, test it separately from actual
failure.

Example:

"No active Training Block"

may be a valid UI state if the confirmed API/application contract defines it
that way.

A network failure is not equivalent to no Training Block.

Tests should preserve this distinction.

---

# 11. Test Naming

Test names should describe observable behavior.

Prefer names such as:

- returns clients when repository succeeds
- emits error state when loading clients fails
- shows add exercises when training block has no program
- hides week selector when no exercises exist

Avoid vague names such as:

- test clients
- test success
- works
- test method

Follow existing repository naming style when it is more specific.

---

# 12. Test Isolation

Tests should not depend on execution order.

Reset mutable state between tests.

Avoid real backend/network dependencies in unit/widget tests unless the
repository already has an explicit integration-test environment for that
purpose.

Use existing mocks/fakes/test helpers.

---

# 13. Do Not Over-Mock

Mock external boundaries and dependencies when appropriate.

Do not mock the exact implementation being tested.

Prefer testing observable behavior rather than verifying every internal method
call.

Tests should allow safe internal refactoring where behavior remains unchanged.

---

# 14. Verification Commands

Before completion, run the verification appropriate to the changed scope.

Common Flutter verification includes:

dart format

flutter analyze

flutter test

Use repository-specific commands when they exist.

For narrowly scoped development, focused tests may be run first.

Before claiming the feature is complete, run the broader applicable checks
when practical.

---

# 15. Static Analysis

Run `flutter analyze` for meaningful Flutter changes when the environment
permits it.

Do not ignore new warnings/errors introduced by the current task.

Do not fix unrelated pre-existing warnings merely to make the task appear
clean.

Report unrelated pre-existing failures separately.

---

# 16. Formatting

Run the Dart formatter against modified Dart code.

Do not perform repository-wide formatting unless explicitly requested.

Formatting-only changes to unrelated files should not be included in a feature
change.

---

# 17. Test Failures

If a test fails:

1. Determine whether the current change caused the failure.
2. Fix failures caused by the current task.
3. Do not silently modify unrelated behavior to make an unrelated test pass.
4. Report pre-existing/unrelated failures clearly.

Do not claim the suite passes when it does not.

---

# 18. Completion Reporting

When reporting completion, explicitly state:

- tests added
- tests modified
- focused tests run
- `flutter analyze` result
- `flutter test` result
- anything that could not be run
- relevant pre-existing failures

Never state that a command passed unless it was actually executed successfully.

---

# 19. Test Scope Control

Testing should increase confidence in the requested change without turning a
feature task into an unrelated test-infrastructure project.

If broader test infrastructure would be valuable but is outside the current
scope, recommend it separately rather than silently introducing it.
