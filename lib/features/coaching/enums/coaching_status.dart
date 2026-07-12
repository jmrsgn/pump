import '../../../core/constants/app/app_strings.dart';

enum CoachingStatus {
  active(AppStrings.active),
  inactive(AppStrings.inactive);

  final String value;

  const CoachingStatus(this.value);

  static CoachingStatus fromValue(String value) {
    return CoachingStatus.values.firstWhere((status) => status.value == value);
  }
}
