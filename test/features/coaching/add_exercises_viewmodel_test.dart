import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/coaching/data/dto/request/create_training_block_request_dto.dart';
import 'package:pump/features/coaching/data/repository/training_block_repository_impl.dart';
import 'package:pump/features/coaching/data/service/training_block_service.dart';
import 'package:pump/features/coaching/domain/entity/training_block.dart';
import 'package:pump/features/coaching/domain/entity/training_program_input.dart';
import 'package:pump/features/coaching/domain/repository/training_block_repository.dart';
import 'package:pump/features/coaching/domain/usecases/add_training_exercises_usecase.dart';
import 'package:pump/features/coaching/presentation/viewmodels/add_exercises_viewmodel.dart';
import 'package:pump/core/data/repository/user_repository_impl.dart';

class _TrainingBlockRepositoryFake implements TrainingBlockRepository {
  TrainingProgramInput? submittedInput;
  Future<Result<void, AppError>> Function()? submission;
  int submissions = 0;

  @override
  Future<Result<void, AppError>> addTrainingExercises(
    TrainingProgramInput input,
  ) {
    submissions++;
    submittedInput = input;
    return submission!();
  }

  @override
  Future<Result<TrainingBlock, AppError>> createTrainingBlock(
    String clientId,
    CreateTrainingBlockRequest request,
  ) => throw UnimplementedError();

  @override
  Future<Result<TrainingBlock, AppError>> getActiveTrainingBlock(
    String clientId,
  ) => throw UnimplementedError();
}

void main() {
  final block = TrainingBlock(
    id: 'block-id',
    clientId: 'client-id',
    trainingBlockName: 'PPL Split',
    numberOfWeeks: 12,
    trainingDays: 2,
    trainingSplit: 'Push, Pull',
    estimatedMacros: 2000,
    targetProteinInGrams: 150,
    targetCarbsInGrams: 220,
    targetFatInGrams: 60,
    requiredDailySteps: 10000,
    otherNotes: null,
    status: 'ACTIVE',
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );

  late _TrainingBlockRepositoryFake repository;
  late AddExercisesViewModel viewModel;

  setUp(() {
    repository = _TrainingBlockRepositoryFake();
    viewModel = AddExercisesViewModel(AddTrainingExercisesUseCase(repository));
    viewModel.initialize(block);
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('keeps exercises on their day and renumbers after removal', () {
    viewModel.addExercise(0);
    viewModel.addExercise(0);
    viewModel.addExercise(1);
    viewModel.editExercise(
      0,
      0,
      name: 'Bench Press',
      minReps: '8',
      maxReps: '10',
    );
    viewModel.editExercise(
      0,
      1,
      name: 'Incline Press',
      minReps: '10',
      maxReps: '12',
    );
    viewModel.editExercise(
      1,
      0,
      name: 'Lat Pulldown',
      minReps: '8',
      maxReps: '12',
    );

    expect(viewModel.state.days[0].exercises.length, 2);
    expect(viewModel.state.days[1].exercises.length, 1);

    final input = viewModel.buildSubmissionInput(block.id)!;
    expect(input.trainingBlockId, block.id);
    expect(input.days.map((day) => day.dayNumber), [1, 2]);
    expect(input.days[0].exercises.map((exercise) => exercise.exerciseOrder), [
      1,
      2,
    ]);
    expect(input.days[1].exercises.single.exerciseOrder, 1);
    expect(input.days[1].exercises.single.exerciseName, 'Lat Pulldown');

    viewModel.removeExercise(0, 0);
    final updatedInput = viewModel.buildSubmissionInput(block.id)!;
    expect(updatedInput.days[0].exercises.single.exerciseName, 'Incline Press');
    expect(updatedInput.days[0].exercises.single.exerciseOrder, 1);
    expect(updatedInput.days[1].exercises.single.exerciseName, 'Lat Pulldown');
  });

  test('rejects missing day and exercise names', () {
    viewModel.renameDay(0, '  ');
    expect(viewModel.buildSubmissionInput(block.id), isNull);
    expect(viewModel.state.errorMessage, contains('Day 1'));

    viewModel.renameDay(0, 'Push');
    viewModel.addExercise(0);
    expect(viewModel.buildSubmissionInput(block.id), isNull);
    expect(viewModel.state.errorMessage, contains('exercise 1'));
  });

  test('rejects invalid rep ranges before submission', () {
    viewModel.addExercise(0);
    viewModel.editExercise(0, 0, name: 'Bench Press');

    for (final reps in [('abc', '10'), ('0', '10'), ('8', '-1'), ('10', '8')]) {
      viewModel.editExercise(0, 0, minReps: reps.$1, maxReps: reps.$2);
      expect(viewModel.buildSubmissionInput(block.id), isNull);
      expect(viewModel.state.errorMessage, isNotNull);
    }
    expect(repository.submittedInput, isNull);
  });

  test('exposes loading and failure without reporting persistence', () async {
    final completion = Completer<Result<void, AppError>>();
    repository.submission = () => completion.future;
    final submission = viewModel.submit(block.id);

    expect(viewModel.state.isLoading, isTrue);
    expect(viewModel.state.isSubmitSuccess, isFalse);
    expect(repository.submittedInput?.days.length, 2);
    await viewModel.submit(block.id);
    expect(repository.submissions, 1);

    completion.complete(Result.failure(AppError(message: 'Unavailable')));
    await submission;

    expect(viewModel.state.isLoading, isFalse);
    expect(viewModel.state.errorMessage, 'Unavailable');
    expect(viewModel.state.isSubmitSuccess, isFalse);
  });

  test('marks success only when the repository reports success', () async {
    repository.submission = () async => const Result.success(null);
    await viewModel.submit(block.id);
    expect(viewModel.state.isSubmitSuccess, isTrue);
    expect(viewModel.state.errorMessage, isNull);
  });

  test('current repository boundary reports API unavailable', () async {
    final currentRepository = TrainingBlockRepositoryImpl(
      TrainingBlockService(),
      UserRepositoryImpl(),
    );
    final input = viewModel.buildSubmissionInput(block.id)!;

    final result = await currentRepository.addTrainingExercises(input);

    expect(result.isFailure, isTrue);
    expect(result.error?.message, contains('unavailable'));
  });
}
