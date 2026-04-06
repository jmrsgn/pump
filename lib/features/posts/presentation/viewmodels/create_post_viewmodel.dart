import 'package:pump/core/constants/app/app_error_strings.dart';
import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/features/posts/domain/usecases/create_post_usecase.dart';
import 'package:pump/features/posts/presentation/providers/create_post_state.dart';

import '../../../../core/utilities/logger_utility.dart';

class CreatePostViewModel extends BaseViewmodel<CreatePostState> {
  final CreatePostUseCase _createPostUseCase;

  CreatePostViewModel(this._createPostUseCase)
    : super(CreatePostState.initial());

  @override
  CreatePostState copyWithState({bool? isLoading, String? errorMessage}) {
    return state.copyWith(isLoading: isLoading, errorMessage: errorMessage);
  }

  Future<void> createPost(String title, String description) async {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [createPost] title: [$title] description: [$description]",
    );

    if (description.trim().isEmpty) {
      return emitError(AppErrorStrings.postDescriptionAreRequired);
    }

    try {
      final response = await _createPostUseCase.execute(title, description);
      if (response.isSuccess) {
        state = state.copyWith(isLoading: false, errorMessage: null);
      } else {
        LoggerUtility.d(runtimeType.toString(), response.error);
        emitError(response.error!.message);
      }
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "createPost", e, stack);
      emitUnexpectedError();
    }
  }
}
