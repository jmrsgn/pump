class CheckInDateUtils {
  CheckInDateUtils._();

  static int daysUntilSunday(DateTime date) =>
      (DateTime.sunday - date.weekday) % DateTime.daysPerWeek;

  static DateTime currentOrNextSunday(DateTime date) {
    return DateTime(date.year, date.month, date.day + daysUntilSunday(date));
  }

  static String? approachingLabel(int daysRemaining) => switch (daysRemaining) {
    0 => 'Check-in today',
    1 => 'Tomorrow',
    2 => '2 days left',
    3 => '3 days left',
    _ => null,
  };
}
