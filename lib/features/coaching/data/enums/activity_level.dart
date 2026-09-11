import 'package:pump/core/constants/app/app_strings.dart';

enum ActivityLevel {
  sedentary(AppStrings.sedentary),
  lightlyActive(AppStrings.lightlyActive),
  moderatelyActive(AppStrings.moderatelyActive),
  veryActive(AppStrings.veryActive);

  final String value;

  const ActivityLevel(this.value);

  static ActivityLevel fromValue(String value) {
    return ActivityLevel.values.firstWhere(
      (activityLevel) => activityLevel.value == value,
    );
  }
}
