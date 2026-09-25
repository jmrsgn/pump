import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/presentation/provider/user_providers.dart';
import 'package:pump/features/coaching/data/repository/training_block_repository_impl.dart';
import 'package:pump/features/coaching/data/service/training_block_service.dart';
import 'package:pump/features/coaching/domain/usecases/create_training_block_usecase.dart';
import 'package:pump/features/coaching/domain/usecases/get_active_training_block_usecase.dart';
import 'package:pump/features/coaching/presentation/state/add_exercises_state.dart';
import 'package:pump/features/coaching/presentation/state/client_info_screen_state.dart';
import 'package:pump/features/coaching/presentation/state/create_training_block_state.dart';
import 'package:pump/features/coaching/presentation/state/training_block_screen_state.dart';
import 'package:pump/features/coaching/presentation/viewmodels/add_exercises_viewmodel.dart';
import 'package:pump/features/coaching/presentation/viewmodels/client_info_screen_viewmodel.dart';
import 'package:pump/features/coaching/presentation/viewmodels/create_training_block_viewmodel.dart';
import 'package:pump/features/coaching/presentation/viewmodels/training_block_screen_viewmodel.dart';

final trainingBlockScreenViewModelProvider = StateNotifierProvider.autoDispose
    .family<TrainingBlockScreenViewModel, TrainingBlockScreenState, String>(
      (ref, blockId) => TrainingBlockScreenViewModel(),
    );

final addExercisesViewModelProvider = StateNotifierProvider.autoDispose
    .family<AddExercisesViewModel, AddExercisesState, String>(
      (ref, blockId) => AddExercisesViewModel(),
    );

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

final getActiveTrainingBlockUseCaseProvider =
    Provider<GetActiveTrainingBlockUseCase>(
      (ref) => GetActiveTrainingBlockUseCase(
        ref.watch(trainingBlockRepositoryProvider),
      ),
    );

final clientInfoScreenViewModelProvider = StateNotifierProvider.autoDispose
    .family<ClientInfoScreenViewModel, ClientInfoScreenState, String>(
      (ref, clientId) => ClientInfoScreenViewModel(
        ref.watch(getActiveTrainingBlockUseCaseProvider),
      ),
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
