import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/features/auth/domain/usecases/logout_usecase.dart';
import 'package:pump/features/auth/presentation/viewmodels/logout_viewmodel.dart';
import 'package:pump/features/auth/presentation/viewmodels/register_viewmodel.dart';
import '../../../../core/presentation/providers/ui_state.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/auth_service.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../viewmodels/login_viewmodel.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authRepositoryProvider = Provider<AuthRepositoryImpl>(
  (ref) => AuthRepositoryImpl(ref.watch(authServiceProvider)),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);

final registerUseCaseProvider = Provider<RegisterUseCase>(
  (ref) => RegisterUseCase(ref.watch(authRepositoryProvider)),
);

final logoutUseCaseProvider = Provider<LogoutUseCase>(
  (ref) => LogoutUseCase(ref.watch(authRepositoryProvider)),
);

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, UiState>((
  ref,
) {
  return LoginViewModel(ref.watch(loginUseCaseProvider));
});

final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, UiState>((ref) {
      return RegisterViewModel(ref.watch(registerUseCaseProvider));
    });

final logoutViewModelProvider = StateNotifierProvider<LogoutViewmodel, UiState>(
  (ref) {
    return LogoutViewmodel(ref.watch(logoutUseCaseProvider));
  },
);
