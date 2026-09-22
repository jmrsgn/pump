import '../../../../core/constants/app/app_strings.dart';

enum TrainingSplit {
  pull(label: AppStrings.pull),
  legs(label: AppStrings.legs),
  push(label: AppStrings.push),
  rest(label: AppStrings.rest),
  fullBody(label: AppStrings.fullBody),
  upperBody(label: AppStrings.upperBody),
  lowerBody(label: AppStrings.lowerBody),
  cardio(label: AppStrings.cardio);

  final String label;

  const TrainingSplit({required this.label});
}
