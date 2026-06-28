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
final getAuthenticatedUserUseCaseProvider =
    Provider<GetAuthenticatedUserUseCase>(
      (ref) => GetAuthenticatedUserUseCase(ref.watch(userRepositoryProvider)),
    );

// ViewModels
final userViewModelProvider = StateNotifierProvider<UserViewModel, UserState>((
  ref,
) {
  return UserViewModel(ref.watch(getAuthenticatedUserUseCaseProvider));
});
