import '../../../core/constants/app/app_strings.dart';

enum FitnessGoal {
  fatLoss(AppStrings.fatLoss),
  muscleGain(AppStrings.muscleGain),
  maintenance(AppStrings.maintenance),
  recomposition(AppStrings.recomposition);

  final String value;

  const FitnessGoal(this.value);

  static FitnessGoal fromValue(String value) {
    return FitnessGoal.values.firstWhere(
      (fitnessGoal) => fitnessGoal.value == value,
    );
  }
}
