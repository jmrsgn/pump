import 'package:pump/core/constants/error/validation_error_constants.dart';
import 'package:pump/core/presentation/providers/ui_state.dart';
import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/features/posts/domain/usecases/create_post_usecase.dart';

import '../../../../core/utilities/logger_utility.dart';

class CreatePostViewModel extends BaseViewModel<UiState> {
  final CreatePostUseCase _createPostUseCase;

  CreatePostViewModel(this._createPostUseCase) : super(UiState.initial());

  @override
  UiState copyWithState({bool? isLoading, String? errorMessage}) {
    return state.copyWith(isLoading: isLoading, errorMessage: errorMessage);
  }

  // createPost ----------------------------------------------------------------
  Future<void> createPost(String title, String description) async {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [createPost] title: [$title] description: [$description]",
    );

    // Prevent double taps
    if (state.isLoading) return;

    setLoading(true);

    if (description.isEmpty) {
      return emitError(ValidationErrorConstants.postDescriptionIsRequired);
    }

    try {
      final result = await _createPostUseCase.execute(title, description);
      if (result.isSuccess) {
        state = state.copyWith(isLoading: false, errorMessage: null);
      } else {
        LoggerUtility.d(
          runtimeType.toString(),
          "createPost",
          result.error!.message,
        );
        emitError(result.error!.message);
      }
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "createPost", e, stack);
      emitUnexpectedError();
    }
  }
}
