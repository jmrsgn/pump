import 'package:pump/core/constants/app/app_strings.dart';

enum Gender {
  male(AppStrings.male),
  female(AppStrings.female);

  final String value;

  const Gender(this.value);

  static Gender fromValue(String value) {
    return Gender.values.firstWhere((gender) => gender.value == value);
  }
}
