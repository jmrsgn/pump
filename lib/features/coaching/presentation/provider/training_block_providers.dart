import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/presentation/provider/user_providers.dart';
import 'package:pump/features/coaching/data/repository/training_block_repository_impl.dart';
import 'package:pump/features/coaching/data/service/training_block_service.dart';
import 'package:pump/features/coaching/domain/usecases/create_training_block_usecase.dart';
import 'package:pump/features/coaching/presentation/state/create_training_block_state.dart';
import 'package:pump/features/coaching/presentation/viewmodels/create_training_block_viewmodel.dart';

final trainingBlockServiceProvider = Provider<TrainingBlockService>(
  (ref) => TrainingBlockService(),
);

final trainingBlockRepositoryProvider = Provider<TrainingBlockRepositoryImpl>(
  (ref) => TrainingBlockRepositoryImpl(
    ref.watch(trainingBlockServiceProvider),
    ref.watch(userRepositoryProvider),
  ),
);

final createTrainingBlockUseCaseProvider = Provider<CreateTrainingBlockUseCase>(
  (ref) =>
      CreateTrainingBlockUseCase(ref.watch(trainingBlockRepositoryProvider)),
);

final createTrainingBlockViewModelProvider =
    StateNotifierProvider<
      CreateTrainingBlockViewModel,
      CreateTrainingBlockState
    >(
      (ref) => CreateTrainingBlockViewModel(
        ref.watch(createTrainingBlockUseCaseProvider),
      ),
    );
