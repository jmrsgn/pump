import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Generic base viewmodel for any UiState-like class.
abstract class BaseViewmodel<T> extends StateNotifier<T> {
  BaseViewmodel(super.state);

  /// Must be implemented by child classes (how to copy state)
  T copyWithState({bool? isLoading, String? errorMessage});

  void setLoading(bool value) {
    state = copyWithState(isLoading: value);
  }

  void emitError(String message) {
    state = copyWithState(isLoading: false, errorMessage: message);
  }

  /// For unexpected errors
  void emitUnexpectedError() {
    emitError("An unexpected error occurred");
  }
}
