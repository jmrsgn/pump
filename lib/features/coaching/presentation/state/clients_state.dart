import 'package:pump/core/presentation/state/ui_state.dart';

import '../../domain/entity/client_user.dart';

class ClientsState extends UiState {
  final List<ClientUser> clients;
  final String searchQuery;

  const ClientsState({
    required super.isLoading,
    super.errorMessage,
    required this.clients,
    required this.searchQuery,
  });

  @override
  ClientsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ClientUser>? clients,
    String? searchQuery,
  }) {
    return ClientsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      clients: clients ?? this.clients,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  factory ClientsState.initial() {
    return const ClientsState(
      isLoading: false,
      errorMessage: null,
      clients: [],
      searchQuery: '',
    );
  }
}
