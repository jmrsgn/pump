import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/data/service/user_service.dart';
import 'package:pump/core/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:pump/core/domain/usecases/search_users_usecase.dart';

import '../../data/repository/user_repository_impl.dart';
import '../state/user_state.dart';
import '../viewmodels/user_viewmodel.dart';

// Services
final userServiceProvider = Provider<UserService>((ref) => UserService());

// Repositories
final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  return UserRepositoryImpl(ref.watch(userServiceProvider));
});

// UseCases
final getAuthenticatedUserUseCaseProvider =
    Provider<GetAuthenticatedUserUseCase>(
      (ref) => GetAuthenticatedUserUseCase(ref.watch(userRepositoryProvider)),
    );

final searchUsersUseCaseProvider = Provider<SearchUsersUseCase>(
  (ref) => SearchUsersUseCase(ref.watch(userRepositoryProvider)),
);

// ViewModels
final userViewModelProvider = StateNotifierProvider<UserViewModel, UserState>((
  ref,
) {
  return UserViewModel(ref.watch(getAuthenticatedUserUseCaseProvider));
});
