---
name: api-integration
description: "Integrate a new Pump mobile backend API using this repository's Service, Repository, DTO/domain, use-case, Riverpod ViewModel, and screen conventions. Use when adding a real HTTP-backed capability; do not use for presentation-only work."
---

# Pump API Integration

Implement an API capability by extending the nearest existing Pump feature pattern. The backend implementation or confirmed API contract is authoritative for API behavior. The existing Flutter codebase is authoritative for how that contract should be integrated into Pump. Do not infer either from UI requirements. Inspect the target feature and its backend contract before selecting names, fields, routes, request encoding, or pagination behavior.

## Before implementation

1. Inspect the backend endpoint or other authoritative API contract.
2. Inspect the nearest equivalent Flutter implementation.
3. Trace the existing feature layers before creating new files.
4. Reuse existing DTOs, entities, repositories, providers, and ViewModels where appropriate.
5. Determine the minimum set of layers/files that actually need to change.
6. If the backend contract cannot be verified, do not guess it.

## Established flow

For the implemented Auth, Social, and Coaching APIs, the normal flow is:

```text
Consumer screen → StateNotifier ViewModel → use case → domain repository
→ data repository implementation → HTTP service → backend
```

Providers assemble the dependency chain and expose the ViewModel. DTOs remain in the `data` layer; DTO-to-domain conversion is defined by the existing DTO mapping methods and invoked by repositories before exposing domain entities. Repositories expose `Result<T, AppError>` to the use-case/presentation side.

Use these repository examples as the primary references:

- Auth: `lib/features/auth/data/service/auth_service.dart` → `data/repository/auth_repository_impl.dart` → `domain/usecases/login_usecase.dart` → `presentation/provider/auth_providers.dart` → `presentation/viewmodels/login_viewmodel.dart` → `presentation/screens/login_screen.dart`.
- Posts: `lib/features/posts/data/service/post_service.dart` → `data/repository/post_repository_impl.dart` → `domain/usecases/get_posts_usecase.dart` → `presentation/provider/post_providers.dart` → `presentation/viewmodels/main_feed_viewmodel.dart` → `presentation/screens/main_feed_screen.dart`.
- Coaching clients: `lib/features/coaching/data/service/client_user_service.dart` → `data/repository/client_user_repository_impl.dart` → `domain/usecases/get_client_users_usecase.dart` → `presentation/provider/client_user_providers.dart` → `presentation/viewmodels/clients_viewmodel.dart` → `presentation/screens/clients_screen.dart`.

## Layer responsibilities and conventions

### Contract and constants

- Confirm the owning service and its API contract; do not create fields or endpoint behavior from UI needs.
- Add confirmed endpoint composition to `lib/core/constants/api/api_constants.dart`, grouped by service. The existing app uses an Auth, Social, and Coaching base URL.
- Preserve the backend response envelope currently expected by services (`data` on success and `error` on failure) only if the new contract uses it.

### Data DTO and HTTP service

- Put feature request and response transfer models in `features/<feature>/data/dto/request` and `response` as applicable. Keep JSON parsing/serialization and entity conversion on the DTO (for example `PostResponse.toPost()` and `ClientUserResponse.toClientUser()`).
- Name HTTP classes `<Resource>Service` in `data/service`. They use `package:http`, build a `Uri` from `ApiConstants`, decode the HTTP response, and return `Result<DTO-or-paged-DTO, ApiErrorResponse>`.
- Pass the JWT into protected service methods and attach `Authorization: Bearer <token>` at the service boundary. Current protected post and coaching services follow this pattern; login/register do not.
- Use the contract’s content type. Current JSON calls reuse `ApiConstants.headerTypeJson`; post creation is the established multipart exception (`http.MultipartRequest`) in `post_service.dart`.
- Handle known success statuses deliberately. On failure, parse the `error` envelope into `ApiErrorResponse`. Catch transport/parsing failures, log context and stack with `LoggerUtility`, and return the existing generic internal-error response. Never log a token, credential, or unnecessary user data.

### Domain repository and use case

- Define a feature-domain repository abstraction in `domain/repository`. Its public results use domain entities and `AppError`, not API DTOs.
- Implement it as `<Resource>RepositoryImpl` in `data/repository`. For authenticated operations, retrieve the authenticated user through `UserRepositoryImpl`; return `AuthErrorConstants.userIsNotAuthenticated` when it is unavailable. The repository calls the service, maps DTOs to entities, preserves paging metadata in `PagedResponse<T>`, and translates `ApiErrorResponse` to `AppError`.
- Add a narrow `<Verb><Resource>UseCase` with `execute(...)` under `domain/usecases`. Existing use cases are usually thin pass-throughs; build request DTOs there when the current feature does so (Auth login is the example).

### Riverpod provider, state, and ViewModel

- In the feature’s `presentation/provider` file, wire `Provider`s in order: service, repository implementation, use case, then `StateNotifierProvider<ViewModel, State>`. Reuse a shared provider only where it is already the application dependency, such as `userRepositoryProvider`.
- When a ViewModel is appropriate, follow the existing `BaseViewModel<T>` pattern used by the feature. Use a feature state extending `UiState` when the screen needs payload, paging, or action-specific flags; use plain `UiState` for a simple command. Preserve immutable `copyWith` state transitions.
- Prevent duplicate actions while `isLoading`, perform client-side validation only for immediate UX, set loading before the request, and clear loading/errors on confirmed success. Propagate safe repository errors via `emitError`; log unexpected exceptions and use `emitUnexpectedError`.
- For a backend-paginated collection, consume the response’s `page`, `size`, and `totalElements`; calculate `hasNext` from those values and append only for load-more. `MainFeedViewModel.getPosts` is the main example.
- Introduce optimistic updates only when the existing feature behavior and failure semantics justify them. Keep a pre-mutation snapshot, roll back on failure, then replace local data with the server response on success. Posts/comments provide the established example in `main_feed_viewmodel.dart` and `post_info_viewmodel.dart`.

### Screen

- Choose the existing Riverpod widget type appropriate for the screen. Use `ConsumerStatefulWidget` when local lifecycle/state is required. Obtain commands with `ref.read(<viewModelProvider>.notifier)`, render state with `ref.watch`, and handle one-time navigation/snackbar effects with `ref.listen`, following the nearest existing screen.
- Start screen-owned initial loads after construction (`Future.microtask` or post-frame callback, matching the nearest screen), dispose controllers/listeners, and use the project’s `CustomScaffold`/`UiUtils` feedback conventions.
- Keep widgets responsible for user input, rendering, and navigation. Keep HTTP, DTO mapping, auth-token lookup, and business/data transitions out of the screen.

## Observed variation—do not normalize silently

- Auth persists the returned access token and user in `SecureStorage` inside `AuthRepositoryImpl`; Social and Coaching repositories retrieve that authenticated context before protected requests. New auth behavior may need this extra persistence step, while ordinary protected APIs should use the established retrieval path.
- Search users returns a list, while posts/comments/client lists use `PagedResponse`; pagination must follow the actual backend contract. The current Clients screen intentionally fetches only page 0 despite receiving a paged result, so do not treat that as the standard pagination implementation.
- `PostInfoViewModel` directly reads `mainFeedViewModelProvider` to synchronize post changes. This cross-ViewModel coupling exists for social consistency but is not a default dependency to copy into unrelated APIs.

## Completion checks

- Verify the endpoint, request/response fields, status codes, auth requirement, media encoding, and pagination behavior against an available backend contract. If it is unavailable, stop short of inventing it and state what is needed.
- Verify DTO serialization/parsing, DTO-to-domain mapping, repository error translation, and the intended ViewModel success/error/loading transitions.
- Test the smallest relevant unit/widget/API-mocked coverage already supported by the repository, and run formatting plus relevant static analysis/tests when the environment permits. Report exactly what ran and what could not run.
- Do not modify backend contracts, generated files, dependencies, or unrelated presentation architecture as a side effect of adding the mobile API integration.
