import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/core/utilities/logger_utility.dart';
import 'package:pump/features/coaching/domain/usecases/get_client_users_usecase.dart';
import 'package:pump/features/coaching/presentation/state/clients_state.dart';

import '../../domain/entity/client_user.dart';

class ClientsViewModel extends BaseViewModel<ClientsState> {
  final GetClientUsersUseCase _getClientUsersUseCase;

  ClientsViewModel(this._getClientUsersUseCase) : super(ClientsState.initial());

  @override
  ClientsState copyWithState({bool? isLoading, String? errorMessage}) {
    return state.copyWith(isLoading: isLoading, errorMessage: errorMessage);
  }

  // getClientUsers ------------------------------------------------------------
  Future<void> getClientUsers(int page) async {
    LoggerUtility.d(runtimeType.toString(), 'Execute method: [getClients]');

    if (state.isLoading) return;

    setLoading(true);

    try {
      final result = await _getClientUsersUseCase.execute(page);

      if (!result.isSuccess || result.data == null) {
        setLoading(false);
        return emitError(result.error!.message);
      }

      final paged = result.data!;

      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
        clients: paged.content,
      );
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), 'getClientUsers', e, stack);
      emitUnexpectedError();
    }
  }

  // searchClients -----------------------------------------------------------
  void searchClients(String query) {
    LoggerUtility.d(
      runtimeType.toString(),
      'Execute method: [searchClients] query: [$query]',
    );

    state = state.copyWith(searchQuery: query);
  }

  // filteredClients ---------------------------------------------------------
  List<ClientUser> get filteredClients {
    final query = state.searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return state.clients;
    }

    return state.clients.where((client) {
      final fullName = '${client.firstName} ${client.lastName}'.toLowerCase();

      return fullName.contains(query);
    }).toList();
  }
}
