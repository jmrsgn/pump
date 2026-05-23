import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/domain/usecases/get_authenticated_user_usecase.dart';

import '../../data/repository/user_repository_impl.dart';
import '../state/user_state.dart';
import '../viewmodels/user_viewmodel.dart';

// Repositories
final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  return UserRepositoryImpl();
});

// UseCases
final getUserProfileUseCaseProvider = Provider<GetAuthenticatedUserUseCase>(
  (ref) => GetAuthenticatedUserUseCase(ref.watch(userRepositoryProvider)),
);

// ViewModels
final userViewModelProvider = StateNotifierProvider<UserViewModel, UserState>((
  ref,
) {
  final repo = ref.watch(userRepositoryProvider);
  final getUserProfileUseCase = GetAuthenticatedUserUseCase(repo);
  return UserViewModel(getUserProfileUseCase);
});
