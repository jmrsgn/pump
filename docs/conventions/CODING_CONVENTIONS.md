# Pump Flutter Coding Conventions

## Purpose

This document defines coding conventions for the Pump Flutter application.

Apply these rules to newly created code and code directly modified by the
current task.

Do not perform unrelated repository-wide formatting or refactoring solely to
make older code conform.

---

# 1. Use Case Naming

Use Case classes must describe the action they perform.

Format:

<Action><Subject>UseCase

Examples:

GetClientsUseCase
GetTrainingBlockUseCase
CreateTrainingBlockUseCase
AddTrainingExercisesUseCase
EnrollClientUseCase

Avoid vague names such as:

ClientsUseCase
TrainingBlockUseCase
ClientUseCase

when the class performs a specific action.

---

# 2. Dependency Variable Naming

Variables storing class dependencies should derive directly from the class name
using lowerCamelCase.

Correct:

GetClientsUseCase getClientsUseCase

GetTrainingBlockUseCase getTrainingBlockUseCase

CreateTrainingBlockUseCase createTrainingBlockUseCase

Incorrect:

GetClientsUseCase clientsUseCase
GetClientsUseCase useCase
GetClientsUseCase getter

Example:

class ClientsViewModel extends StateNotifier<ClientsState> {
final GetClientsUseCase getClientsUseCase;

ClientsViewModel({
required this.getClientsUseCase,
}) : super(const ClientsState());
}

This convention applies consistently to other injected classes where
reasonable.

Prefer predictable names over aliases.

---

# 3. Method Naming

Methods should describe the action they perform.

Example:

GetClientsUseCase
→ getClientsUseCase
→ getClients()

GetTrainingBlockUseCase
→ getTrainingBlockUseCase
→ getTrainingBlock()

Prefer established Pump terminology.

Avoid unnecessary abbreviations.

---

# 4. Always Use Braces

Always use braces for control-flow bodies, even for a single statement.

Correct:

if (condition) {
return;
}

Correct:

if (condition) {
doSomething();
} else {
doSomethingElse();
}

Correct:

for (final client in clients) {
processClient(client);
}

Incorrect:

if (condition) return;

Incorrect:

if (condition)
return;

Incorrect:

for (final client in clients) processClient(client);

Apply this convention to applicable:

- if
- else
- else if
- for
- for-in
- while
- do-while

Readability and safe future modification take precedence over saving lines.

---

# 5. Naming

Use names that communicate responsibility clearly.

Prefer:

clientInfoViewModel
getClientsUseCase
trainingBlockRepository
trainingBlockService
createTrainingBlock()

Avoid ambiguous names such as:

data
manager
handler
helper
thing
temp

unless the meaning is genuinely clear from a very small local scope.

Follow existing Pump terminology.

---

# 6. Class Responsibility

Keep classes focused on their established responsibility.

Do not add unrelated behavior to a class merely because it is convenient.

Examples:

- Screens render UI and forward user actions.
- ViewModels own screen behavior/state.
- Use Cases represent actions.
- Repositories define data/domain boundaries.
- Repository implementations coordinate data sources/mapping.
- HTTP services handle API transport.
- DTOs represent transport data.

Refer to `ARCHITECTURE_CONVENTIONS.md` for architectural ownership.

---

# 7. Nullability

Model nullability intentionally.

Do not make a field nullable solely to hide a backend defect or avoid handling
an invalid state.

If the confirmed backend contract guarantees a value, model that guarantee
appropriately.

If absence is a valid business state, represent it explicitly.

Avoid unnecessary force unwraps.

---

# 8. Defaults and Fallbacks

Do not introduce fallback values that change the meaning of backend data.

Avoid converting:

- unknown
- missing
- failed
- unauthorized
- not found

into apparently valid data unless that behavior is explicitly part of the
product contract.

Fallback UI text is acceptable when it truthfully represents absence.

---

# 9. Error Handling

Follow the established Pump error/result patterns.

Do not:

- silently swallow failures
- convert arbitrary failures into success
- expose technical backend errors directly to users
- create competing error abstractions for one feature

Preserve useful error context where safe.

---

# 10. Logging

Use existing Pump logging utilities and conventions.

Logs should help identify:

- operation
- location
- failure reason when known

Never log:

- JWTs
- credentials
- secrets
- sensitive user information unnecessarily

Do not introduce another logging framework for a feature.

---

# 11. Imports

Follow existing Dart import organization in the repository.

Prefer project-established import style.

Remove imports made unused by the current change.

Do not perform unrelated repository-wide import reordering.

---

# 12. Constants

Use existing constant structures when an appropriate owner already exists.

Do not create a new constants class for every individual value.

Avoid scattering repeated meaningful literals throughout the implementation.

Do not turn every local value into a global constant unnecessarily.

---

# 13. Comments

Prefer clear code over comments that simply repeat the implementation.

Use comments when they explain:

- non-obvious intent
- important constraints
- architectural reasons
- unusual backend behavior
- decisions that would otherwise be easy to misunderstand

Do not leave stale comments after changing behavior.

---

# 14. Async Code

Handle asynchronous operations deliberately.

Consider:

- loading state
- success state
- error state
- repeated submission
- stale state
- screen lifecycle where applicable

Do not fire duplicate backend requests accidentally.

Follow existing ViewModel/Riverpod async patterns.

---

# 15. Scope Control

When modifying an existing file:

- change what the task requires
- bring directly affected code into compliance where safe
- do not reformat unrelated sections
- do not rename unrelated symbols
- do not refactor neighboring features without need

A feature task should not become an unsolicited cleanup task.

---

# 16. Formatting

Use the repository's standard Dart formatter.

Before completion, format modified Dart files.

Do not manually fight standard Dart formatting.

These conventions define structural/readability preferences that remain valid
after standard formatting.

---

# 17. Screen ViewModel and State Access

Screens should define their ViewModel access once near the top of the screen
State class rather than repeatedly reading the ViewModel provider throughout
the implementation.

For a `ConsumerState`, define the ViewModel getter near the top of the class,
after local fields/controllers and before lifecycle methods.

Example:

```dart
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
