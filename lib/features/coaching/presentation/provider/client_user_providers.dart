import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/presentation/provider/user_providers.dart';
import 'package:pump/features/coaching/data/repository/client_user_repository_impl.dart';
import 'package:pump/features/coaching/data/service/client_user_service.dart';
import 'package:pump/features/coaching/domain/usecases/create_client_user_usecase.dart';
import 'package:pump/features/coaching/domain/usecases/get_client_users_usecase.dart';
import 'package:pump/features/coaching/presentation/state/enroll_client_state.dart';
import 'package:pump/features/coaching/presentation/viewmodels/clients_viewmodel.dart';

import '../../../../core/domain/usecases/search_users_usecase.dart';
import '../state/clients_state.dart';
import '../viewmodels/enroll_client_viewmodel.dart';

// Services
final clientUserServiceProvider = Provider<ClientUserService>((ref) {
  return ClientUserService();
});

// Repositories
final clientUserRepositoryProvider = Provider<ClientUserRepositoryImpl>((ref) {
  return ClientUserRepositoryImpl(
    ref.watch(clientUserServiceProvider),
    ref.watch(userRepositoryProvider),
  );
});

// UseCases
final createClientUserUseCaseProvider = Provider<CreateClientUserUseCase>(
  (ref) => CreateClientUserUseCase(ref.watch(clientUserRepositoryProvider)),
);

final getClientUsersUseCaseProvider = Provider<GetClientUsersUseCase>(
  (ref) => GetClientUsersUseCase(ref.watch(clientUserRepositoryProvider)),
);

final searchUsersUseCaseProvider = Provider<SearchUsersUseCase>(
  (ref) => SearchUsersUseCase(ref.watch(clientUserRepositoryProvider)),
);

// ViewModels
final enrollClientViewModelProvider =
    StateNotifierProvider<EnrollClientViewModel, EnrollClientState>((ref) {
      return EnrollClientViewModel(
        ref.watch(createClientUserUseCaseProvider),
        ref.watch(searchUsersUseCaseProvider),
      );
    });

final clientsViewModelProvider =
    StateNotifierProvider<ClientsViewModel, ClientsState>((ref) {
      return ClientsViewModel(ref.watch(getClientUsersUseCaseProvider));
    });
