# Pump Flutter Coding Conventions

## Purpose

This document defines coding conventions for the Pump Flutter
application.

Apply these rules to newly created code and code directly modified by
the current task.

Do not perform unrelated repository-wide formatting, renaming, cleanup,
or refactoring solely to make older code conform.

These conventions complement `architecture-conventions.md`.
Architectural ownership takes precedence when a coding decision affects
layer responsibilities or dependency direction.

------------------------------------------------------------------------

## 1. General Principles

Prefer code that is:

-   clear;
-   predictable;
-   focused;
-   consistent with existing Pump terminology;
-   easy to modify safely;
-   explicit when behavior or ownership would otherwise be ambiguous.

Prefer established Pump patterns over introducing a new local convention
for one feature.

Do not add abstraction merely to reduce line count.

Do not copy an older pattern into new code when it clearly conflicts
with the current conventions.

------------------------------------------------------------------------

## 2. Use Case Naming

Use Case classes must describe the action they perform.

Format:

``` text
<Action><Subject>UseCase
```

Examples:

``` dart
GetClientsUseCase
GetTrainingBlockUseCase
CreateTrainingBlockUseCase
AddTrainingExercisesUseCase
EnrollClientUseCase
```

Avoid vague names such as:

``` dart
ClientsUseCase
TrainingBlockUseCase
ClientUseCase
```

when the class performs a specific action.

Use the terminology of the domain action rather than implementation
terminology such as HTTP verbs.

------------------------------------------------------------------------

## 3. Dependency Variable Naming

Variables storing class dependencies should derive directly from the
class name using `lowerCamelCase`.

Correct:

``` dart
GetClientsUseCase getClientsUseCase;
GetTrainingBlockUseCase getTrainingBlockUseCase;
CreateTrainingBlockUseCase createTrainingBlockUseCase;
```

Incorrect:

``` dart
GetClientsUseCase clientsUseCase;
GetClientsUseCase useCase;
GetClientsUseCase getter;
```

Example:

``` dart
class ClientsViewModel extends StateNotifier<ClientsState> {
  final GetClientsUseCase getClientsUseCase;

  ClientsViewModel({
    required this.getClientsUseCase,
  }) : super(const ClientsState());
}
```

Apply this convention consistently to other injected classes where
reasonable.

Examples:

``` dart
TrainingBlockRepository trainingBlockRepository;
TrainingBlockService trainingBlockService;
```

Prefer predictable dependency names over aliases.

------------------------------------------------------------------------

## 4. Method Naming

Methods should describe the action they perform.

Example:

``` text
GetClientsUseCase
→ getClientsUseCase
→ getClients()

GetTrainingBlockUseCase
→ getTrainingBlockUseCase
→ getTrainingBlock()
```

Use verbs that communicate the operation.

Prefer established Pump terminology.

Avoid unnecessary abbreviations.

Do not include implementation details such as `Api`, `Http`, or `Dio` in
application-level method names unless that implementation detail is
genuinely part of the abstraction being named.

Boolean methods and getters should read naturally as conditions when
practical.

Examples:

``` dart
hasActiveTrainingBlock
canSubmit
isLoading
```

------------------------------------------------------------------------

## 5. Class, Type, and File Naming

Follow standard Dart naming conventions and existing Pump repository
organization.

Use:

``` text
UpperCamelCase
```

for classes, enums, typedefs, and other named types.

Use:

``` text
lowerCamelCase
```

for variables, parameters, methods, getters, and setters.

Use:

``` text
lowercase_with_underscores.dart
```

for Dart filenames.

Examples:

``` text
ClientInfoViewModel
TrainingBlockRepository
FitnessGoal

clientInfoViewModel
trainingBlockRepository
getTrainingBlock()

client_info_view_model.dart
training_block_repository.dart
```

A file should be named for its primary responsibility.

Do not create multiple differently named definitions for the same domain
concept.

Before introducing a new enum, model, or shared type, search for an
existing canonical definition and reuse it when appropriate.

------------------------------------------------------------------------

## 6. Naming Clarity

Use names that communicate responsibility clearly.

Prefer:

``` dart
clientInfoViewModel
getClientsUseCase
trainingBlockRepository
trainingBlockService
createTrainingBlock()
```

Avoid ambiguous names such as:

``` text
data
manager
handler
helper
thing
temp
```

unless the meaning is genuinely clear from a very small local scope.

Names should communicate domain meaning rather than merely the data
type.

For example, prefer:

``` dart
final clients = ...
```

over:

``` dart
final list = ...
```

when the collection contains clients.

Follow existing Pump terminology consistently across screens,
ViewModels, Use Cases, repositories, DTOs, and domain models.

------------------------------------------------------------------------

## 7. Class Responsibility

Keep classes focused on their established responsibility.

Examples:

-   Screens render UI and forward user actions.
-   ViewModels own screen behavior and presentation state.
-   Use Cases represent application actions.
-   Domain repositories define data/domain contracts.
-   Repository implementations coordinate data sources and mapping.
-   HTTP services handle API transport.
-   DTOs represent transport data.
-   Domain models represent application/domain concepts.

Refer to `architecture-conventions.md` for authoritative architectural
ownership.

Do not add unrelated behavior to a class merely because it is
convenient.

Do not create a generic `Manager`, `Helper`, or `Utils` class as a
default destination for behavior that has a clearer owner.

------------------------------------------------------------------------

## 8. Function and Method Size

Keep methods focused on one coherent responsibility.

Extract logic when a method becomes difficult to understand because it
mixes distinct responsibilities.

Good reasons to extract include:

-   a meaningful operation has its own name;
-   the same behavior is genuinely reused;
-   complex branching becomes easier to understand;
-   parsing, mapping, validation, or transformation has a clearer owner
    elsewhere.

Do not extract trivial one-line methods solely to make a method shorter.

Prefer readable control flow over excessive indirection.

------------------------------------------------------------------------

## 9. Always Use Braces

Always use braces for control-flow bodies, even for a single statement.

Correct:

``` dart
if (condition) {
  return;
}
```

Correct:

``` dart
if (condition) {
  doSomething();
} else {
  doSomethingElse();
}
```

Correct:

``` dart
for (final client in clients) {
  processClient(client);
}
```

Incorrect:

``` dart
if (condition) return;
```

Incorrect:

``` dart
if (condition)
  return;
```

Incorrect:

``` dart
for (final client in clients) processClient(client);
```

Apply this convention to applicable:

-   `if`;
-   `else`;
-   `else if`;
-   `for`;
-   `for-in`;
-   `while`;
-   `do-while`.

Readability and safe future modification take precedence over saving
lines.

------------------------------------------------------------------------

## 10. Early Returns and Control Flow

Prefer straightforward control flow.

Use early returns when they reduce unnecessary nesting and make
preconditions or failure paths clearer.

Example:

``` dart
if (!canSubmit) {
  return;
}

await submit();
```

Avoid deeply nested conditionals when the same behavior can be expressed
clearly with guards or smaller focused operations.

Do not use early returns when they obscure required cleanup or make the
flow harder to reason about.

------------------------------------------------------------------------

## 11. Nullability

Model nullability intentionally.

Do not make a field nullable solely to hide a backend defect or avoid
handling an invalid state.

If the confirmed backend contract guarantees a value, model that
guarantee appropriately.

If absence is a valid business state, represent it explicitly.

Avoid unnecessary force unwraps such as:

``` dart
value!
```

When a force unwrap is genuinely safe, the surrounding invariant should
make that safety clear.

Prefer explicit null handling over chains that silently discard
meaningful failure or absence.

Do not use `late` merely to bypass correct initialization design.

Use `late` only when initialization after construction is intentional
and guaranteed before access.

------------------------------------------------------------------------

## 12. Defaults and Fallbacks

Do not introduce fallback values that change the meaning of backend
data.

Avoid converting:

-   unknown;
-   missing;
-   failed;
-   unauthorized;
-   not found;

into apparently valid data unless that behavior is explicitly part of
the product contract.

For example, do not silently convert a missing authoritative numeric
value into:

``` dart
0
```

if `0` has valid business meaning.

Fallback UI text such as:

``` text
–
Not available
No active Training Block
```

is acceptable when it truthfully represents the confirmed state.

------------------------------------------------------------------------

## 13. Immutability and State Updates

Prefer immutable state and model updates according to existing Pump
patterns.

When a state object uses `copyWith`, update only the fields required by
the transition.

Example:

``` dart
state = state.copyWith(
  isLoading: true,
  error: null,
);
```

Do not mutate collections or state objects in place when the owning
state pattern expects immutable replacement.

When updating collections, preserve ordering and identity semantics
required by the feature.

Avoid maintaining multiple mutable representations of the same state.

------------------------------------------------------------------------

## 14. Collections

Use collection types that communicate the required behavior.

Prefer typed collections.

Example:

``` dart
final List<Client> clients = [];
```

over untyped or overly broad structures.

Do not use `dynamic` collections to avoid modeling known data.

Avoid unnecessary collection copies inside frequently executed UI paths.

When transforming collections, prefer readable Dart collection
operations when they make intent clearer.

Do not compress complex business logic into a long chain of `map`,
`where`, `expand`, or `fold` calls merely for conciseness.

------------------------------------------------------------------------

## 15. Enums and Shared Types

Use enums for finite, known application states or contract values when
appropriate.

Before adding an enum, search for an existing canonical definition.

Do not duplicate an enum in multiple feature locations.

A domain concept should have one authoritative application definition
unless separate representations are intentionally required by different
architectural layers.

If an API DTO requires transport-specific enum parsing, keep transport
mapping at the appropriate data boundary rather than making presentation
code interpret raw API strings repeatedly.

Handle unknown backend enum values according to the confirmed API/error
contract. Do not silently map unknown values to an unrelated valid
state.

------------------------------------------------------------------------

## 16. Error Handling

Follow the established Pump error/result patterns.

When the architecture uses:

``` dart
Result<T, AppError>
```

preserve that contract.

Do not:

-   silently swallow failures;
-   convert arbitrary failures into success;
-   expose technical backend errors directly to users;
-   create competing error abstractions for one feature;
-   use broad exception handling merely to hide programming errors.

Preserve useful error context where safe.

Catch exceptions at the layer that can meaningfully translate, recover
from, or report them.

Do not add:

``` dart
try {
  // ...
} catch (_) {
  // ignore
}
```

unless intentionally ignoring the failure is part of the confirmed
behavior and the reason is clear.

------------------------------------------------------------------------

## 17. Logging

Use existing Pump logging utilities and conventions.

Logs should help identify:

-   operation;
-   location;
-   failure reason when known;
-   relevant non-sensitive context.

Never log:

-   JWTs;
-   credentials;
-   secrets;
-   passwords;
-   authorization headers;
-   sensitive user information unnecessarily.

Do not introduce another logging framework for a feature.

Do not use temporary `print` or `debugPrint` statements as permanent
application logging when an established logging mechanism exists.

Remove temporary debugging output before completion unless it remains
intentionally useful.

------------------------------------------------------------------------

## 18. Async Code

Handle asynchronous operations deliberately.

Consider:

-   loading state;
-   success state;
-   error state;
-   repeated submission;
-   stale state;
-   screen lifecycle where applicable;
-   whether the result is still relevant when the operation completes.

Do not fire duplicate backend requests accidentally.

Await asynchronous operations when subsequent behavior depends on their
completion.

Do not use unawaited asynchronous work unless fire-and-forget behavior
is intentional and safe.

Follow existing ViewModel/Riverpod async patterns.

When an async operation updates screen-owned state, ensure the owning
lifecycle still permits the update according to the repository's
established patterns.

------------------------------------------------------------------------

## 19. Futures and Return Types

Use explicit return types for public and non-trivial methods.

Examples:

``` dart
Future<void> createTrainingBlock()
Future<Result<TrainingBlock, AppError>> getTrainingBlock()
bool canSubmit()
```

Avoid relying on inferred `dynamic`.

Return `Future<void>` when callers only need completion.

Return meaningful values when the caller genuinely needs the result.

Do not return values solely to expose internal implementation details.

------------------------------------------------------------------------

## 20. Parameters and Constructors

Prefer named parameters when they improve call-site clarity, especially
for constructors and methods with multiple values of similar types.

Use `required` when absence is not valid.

Example:

``` dart
const ClientInfoScreen({
  super.key,
  required this.client,
});
```

Do not make required domain input optional merely to simplify a call
site.

Keep constructor dependencies explicit.

Prefer dependency injection through the established provider/constructor
architecture over hidden service lookup.

------------------------------------------------------------------------

## 21. Imports

Follow existing Dart import organization in the repository.

Prefer project-established import style.

Keep imports grouped and ordered according to existing repository
conventions and formatter/analyzer behavior.

Remove imports made unused by the current change.

Do not perform unrelated repository-wide import reordering.

Do not create import aliases unless they resolve a real naming conflict
or materially improve clarity.

When duplicate types exist because of legacy code, fix the ownership
problem when it is safely in scope rather than permanently hiding it
behind import aliases.

------------------------------------------------------------------------

## 22. Constants and Magic Values

Use existing constant structures when an appropriate owner already
exists.

Do not create a new constants class for every individual value.

Avoid scattering repeated meaningful literals throughout the
implementation.

Examples of values that may deserve an established owner include:

-   API-related constants;
-   shared UI dimensions;
-   repeated domain thresholds;
-   shared string values with application meaning.

Do not turn every local value into a global constant unnecessarily.

A value used only inside one small method may remain local when that
ownership is clearer.

Do not duplicate existing constants under a new name.

------------------------------------------------------------------------

## 23. Strings

Use existing application string/constants patterns when a string is
shared or already has an established owner.

Do not extract every one-off internal string merely for abstraction.

User-facing text should remain consistent with existing Pump
terminology.

Avoid embedding backend implementation terminology in user-facing
messages.

Do not expose raw exception messages directly to users unless the
established error contract explicitly provides safe presentation text.

------------------------------------------------------------------------

## 24. Comments

Prefer clear code over comments that simply repeat the implementation.

Use comments when they explain:

-   non-obvious intent;
-   important constraints;
-   architectural reasons;
-   unusual backend behavior;
-   compatibility requirements;
-   decisions that would otherwise be easy to misunderstand.

Good:

``` dart
// Keep the existing list visible while the next page loads.
```

Avoid:

``` dart
// Set loading to true.
state = state.copyWith(isLoading: true);
```

Do not leave stale comments after changing behavior.

Do not use comments to justify code that should instead be made clear
through naming or structure.

------------------------------------------------------------------------

## 25. Documentation Comments

Use Dart documentation comments (`///`) for public APIs or reusable
abstractions when additional explanation is genuinely valuable.

Do not add documentation comments that merely restate the symbol name.

Example:

``` dart
/// Returns the active Training Block for the selected client.
///
/// A successful result may contain no active block when that absence is a
/// valid backend-defined business state.
Future<Result<TrainingBlock?, AppError>> getTrainingBlock();
```

Keep documentation synchronized with behavior.

------------------------------------------------------------------------

## 26. Screen ViewModel and State Access

Screens should define their ViewModel access once near the top of the
screen `State` class rather than repeatedly reading the ViewModel
provider throughout the implementation.

For a `ConsumerState`, define the ViewModel getter near the top of the
class, after local fields/controllers and before lifecycle methods.

Example:

``` dart
class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginViewModel get _loginViewModel =>
      ref.read(loginViewModelProvider.notifier);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);

    // ...
  }
}
```

Use:

``` dart
ref.watch(...)
```

for reactive state consumed by rendering.

Use the screen's ViewModel getter for commands/actions when the
established provider exposes a notifier.

Do not repeatedly write:

``` dart
ref.read(loginViewModelProvider.notifier)
```

throughout the same screen when the screen convention already defines a
ViewModel getter.

------------------------------------------------------------------------

## 27. Controllers and Lifecycle Resources

A screen that owns disposable resources must release them according to
Flutter lifecycle requirements.

Examples include:

-   `TextEditingController`;
-   `FocusNode`;
-   `AnimationController`;
-   other resources with explicit disposal requirements.

Example:

``` dart
@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();
}
```

Keep ownership clear: the object that creates and owns a disposable
screen resource should normally be responsible for disposing it.

Do not move widget-specific controllers into a ViewModel merely to avoid
lifecycle handling in the screen.

------------------------------------------------------------------------

## 28. Widget Build Methods

Keep `build()` focused on describing UI.

Avoid performing:

-   backend requests;
-   dependency construction;
-   state mutation as an incidental result of rendering;
-   expensive repeated transformations;
-   unrelated business logic;

directly inside `build()`.

Compute simple presentation values locally when doing so remains
readable.

Extract meaningful UI sections according to `UI_CONVENTIONS.md` when a
build method becomes difficult to understand.

Do not extract widgets solely to satisfy an arbitrary line-count target.

------------------------------------------------------------------------

## 29. Scope Control

When modifying an existing file:

-   change what the task requires;
-   bring directly affected code into compliance where safe;
-   remove code/imports made obsolete by the current change;
-   do not reformat unrelated sections;
-   do not rename unrelated symbols;
-   do not refactor neighboring features without need.

A feature task should not become an unsolicited cleanup task.

If a broader cleanup would materially improve the repository but is
outside scope, report or recommend it separately.

------------------------------------------------------------------------

## 30. Formatting

Use the repository's standard Dart formatter.

Before completion, format modified Dart files.

Use:

``` bash
dart format <modified-paths>
```

or the repository's established equivalent.

Do not manually fight standard Dart formatting.

Do not run repository-wide formatting unless the task requires it.

These conventions define structural and readability preferences that
remain valid after standard formatting.

------------------------------------------------------------------------

## 31. Static Analysis Discipline

Code introduced or modified by the current task should not add analyzer
errors or warnings.

Use the repository's existing lint configuration.

Do not suppress analyzer findings merely to make a change appear clean
unless the suppression is justified and consistent with repository
conventions.

Avoid introducing new lint packages or changing global analyzer rules as
an incidental part of a feature.

Command-level verification is governed by `testing-conventions.md`.

------------------------------------------------------------------------

## 32. Generated Code

Do not manually edit generated files when the repository's tooling owns
them.

When a task requires generated output:

1.  modify the authoritative source;
2.  run the established generator when available;
3.  include generated changes only when repository conventions expect
    them to be committed.

Do not introduce a new code-generation dependency merely for
convenience.

If a generated file appears incorrect, identify its source or generator
before patching the generated output directly.

------------------------------------------------------------------------

## 33. Temporary and Dead Code

Do not leave temporary implementation artifacts after completing a task.

Remove temporary:

-   debug statements;
-   commented-out implementations;
-   unused variables;
-   obsolete imports;
-   placeholder branches that are no longer required.

Do not delete intentionally retained compatibility or migration code
merely because it appears unused without verifying its purpose.

Avoid speculative code for future features that are not part of the
current requirement.

------------------------------------------------------------------------

## 34. Coding Verification Checklist

Before completing a meaningful code change, verify that:

-   names communicate the correct responsibility;
-   Use Cases follow action-oriented naming;
-   dependency variables follow predictable naming;
-   canonical models/enums/types were reused instead of duplicated;
-   nullability reflects the confirmed contract;
-   defaults do not hide invalid or failed states;
-   state updates follow the established immutable pattern;
-   asynchronous operations do not accidentally duplicate requests;
-   errors are not silently swallowed;
-   no sensitive information is logged;
-   disposable screen resources are released;
-   `build()` remains presentation-focused;
-   generated files were not manually modified incorrectly;
-   temporary/debug code has been removed;
-   modified Dart files are formatted;
-   the change remains within requested scope.

Architecture and dependency ownership are governed by
`architecture-conventions.md`.

Testing and command-level verification are governed by
`testing-conventions.md`.

UI composition and presentation styling are governed by
`ui-conventions.md`.
