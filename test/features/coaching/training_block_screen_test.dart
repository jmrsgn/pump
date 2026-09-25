import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pump/core/app_routes.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/presentation/widgets/custom_text_field.dart';
import 'package:pump/features/coaching/domain/entity/training_block.dart';
import 'package:pump/features/coaching/domain/entity/training_program.dart';
import 'package:pump/features/coaching/presentation/provider/training_block_providers.dart';
import 'package:pump/features/coaching/presentation/screens/add_exercises_screen.dart';
import 'package:pump/features/coaching/presentation/screens/training_block_screen.dart';
import 'package:pump/features/coaching/presentation/viewmodels/training_block_screen_viewmodel.dart';

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

  testWidgets(
    'Training Block uses CustomScaffold and opens the local exercise editor',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            onGenerateRoute: AppRoutes.generateRoute,
            home: TrainingBlockScreen(trainingBlock: block),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CustomScaffold), findsOneWidget);
      expect(find.text('PPL Split'), findsOneWidget);
      expect(find.text('Add Exercises'), findsOneWidget);
      expect(find.text('Week 1'), findsNothing);
      expect(find.text('Prescribed exercises'), findsNothing);

      await tester.tap(find.text('Add Exercises'));
      await tester.pumpAndSettle();
      expect(find.byType(AddExercisesScreen), findsOneWidget);
      expect(find.text('Day 1'), findsOneWidget);
      expect(find.text('Day 2'), findsOneWidget);
      expect(find.text('Save Program'), findsNothing);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is CustomTextField && widget.hint == 'Training day name',
        ),
        findsNWidgets(2),
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is CustomButton &&
              widget.label == 'Add Exercise' &&
              widget.isOutlineButton,
        ),
        findsNWidgets(2),
      );

      await tester.tap(find.text('Add Exercise').first);
      await tester.pumpAndSettle();
      expect(find.text('Exercise 1 • 3 sets'), findsOneWidget);
      expect(find.text('Exercise name'), findsOneWidget);
      expect(find.text('Min reps'), findsOneWidget);
      expect(find.text('Max reps'), findsOneWidget);
    },
  );

  testWidgets(
    'Add Exercises stays available when a local program has exercises',
    (tester) async {
      final program = TrainingProgram(
        trainingBlockId: block.id,
        trainingDays: block.trainingDays,
        days: const [
          ProgramDay(
            id: 'day-id',
            dayNumber: 1,
            dayName: 'Push',
            exercises: [
              ProgramExercise(
                id: 'exercise-id',
                exerciseName: 'Bench Press',
                exerciseOrder: 1,
                targetSets: 3,
                minReps: 8,
                maxReps: 10,
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trainingBlockScreenViewModelProvider(block.id).overrideWith(
              (ref) => TrainingBlockScreenViewModel()..setProgram(program),
            ),
          ],
          child: MaterialApp(
            onGenerateRoute: AppRoutes.generateRoute,
            home: TrainingBlockScreen(trainingBlock: block),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add Exercises'), findsOneWidget);
      expect(find.text('Week 1'), findsWidgets);
      expect(find.text('Prescribed exercises'), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);

      await tester.tap(find.text('Add Exercises'));
      await tester.pumpAndSettle();
      expect(find.byType(AddExercisesScreen), findsOneWidget);
    },
  );

  testWidgets('previews an exercise draft and restores it when editing again', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          onGenerateRoute: AppRoutes.generateRoute,
          home: TrainingBlockScreen(trainingBlock: block),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Exercises'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byKey(const ValueKey('day-name-1')),
        matching: find.byType(TextField),
      ),
      'Upper Body',
    );
    await tester.pump();
    await tester.tap(find.text('Add Exercise').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Exercise name',
      ),
      'Bench Press',
    );
    await tester.pump();
    final editorContainer = ProviderScope.containerOf(
      tester.element(find.byType(AddExercisesScreen)),
    );
    expect(
      editorContainer
          .read(addExercisesViewModelProvider(block.id))
          .days
          .first
          .exercises
          .first
          .name,
      'Bench Press',
    );
    await tester.ensureVisible(find.text('Preview Program'));
    await tester.tap(find.text('Preview Program'));
    await tester.pumpAndSettle();

    expect(find.text('Local preview'), findsOneWidget);
    expect(find.text('Day 1: Upper Body'), findsOneWidget);
    final previewContainer = ProviderScope.containerOf(
      tester.element(find.byType(TrainingBlockScreen)),
    );
    expect(
      previewContainer
          .read(trainingBlockScreenViewModelProvider(block.id))
          .draft
          ?.days
          .first
          .exercises
          .first
          .name,
      'Bench Press',
    );
    expect(find.textContaining('Bench Press'), findsOneWidget);
    expect(
      find.text('This program is not saved to the backend.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Add Exercises'));
    await tester.pumpAndSettle();
    expect(find.text('Exercise 1 • 3 sets'), findsOneWidget);
    expect(
      tester
          .widget<TextField>(
            find.descendant(
              of: find.byKey(const ValueKey('day-name-1')),
              matching: find.byType(TextField),
            ),
          )
          .controller
          ?.text,
      'Upper Body',
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Exercise name' &&
            widget.controller?.text == 'Bench Press',
      ),
      findsOneWidget,
    );
  });

  testWidgets('does not leave the editor when submission API is unavailable', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          onGenerateRoute: AppRoutes.generateRoute,
          home: TrainingBlockScreen(trainingBlock: block),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Exercises'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Submit Program'));
    await tester.tap(find.text('Submit Program'));
    await tester.pumpAndSettle();

    expect(find.byType(AddExercisesScreen), findsOneWidget);
    expect(find.textContaining('submission is unavailable'), findsOneWidget);
    expect(find.text('Local preview'), findsNothing);
  });
}
