import 'package:flutter_test/flutter_test.dart';
import 'package:pump/features/coaching/utils/check_in_date_utils.dart';

void main() {
  group('current or upcoming Sunday', () {
    final cases = <({DateTime date, DateTime sunday, int days})>[
      (date: DateTime(2026, 9, 28, 14), sunday: DateTime(2026, 10, 4), days: 6),
      (date: DateTime(2026, 9, 29), sunday: DateTime(2026, 10, 4), days: 5),
      (date: DateTime(2026, 9, 30), sunday: DateTime(2026, 10, 4), days: 4),
      (date: DateTime(2026, 10, 1), sunday: DateTime(2026, 10, 4), days: 3),
      (date: DateTime(2026, 9, 25, 23), sunday: DateTime(2026, 9, 27), days: 2),
      (date: DateTime(2026, 9, 26, 23), sunday: DateTime(2026, 9, 27), days: 1),
      (date: DateTime(2026, 9, 27, 23), sunday: DateTime(2026, 9, 27), days: 0),
      (date: DateTime(2026, 10, 3), sunday: DateTime(2026, 10, 4), days: 1),
      (date: DateTime(2026, 10, 5), sunday: DateTime(2026, 10, 11), days: 6),
      (date: DateTime(2026, 12, 31), sunday: DateTime(2027, 1, 3), days: 3),
    ];

    for (final testCase in cases) {
      test('${testCase.date} -> ${testCase.sunday}', () {
        expect(
          CheckInDateUtils.currentOrNextSunday(testCase.date),
          testCase.sunday,
        );
        expect(CheckInDateUtils.daysUntilSunday(testCase.date), testCase.days);
      });
    }
  });

  test('approaching label depends on calendar days remaining', () {
    expect(CheckInDateUtils.approachingLabel(6), isNull);
    expect(CheckInDateUtils.approachingLabel(4), isNull);
    expect(CheckInDateUtils.approachingLabel(3), '3 days left');
    expect(CheckInDateUtils.approachingLabel(2), '2 days left');
    expect(CheckInDateUtils.approachingLabel(1), 'Tomorrow');
    expect(CheckInDateUtils.approachingLabel(0), 'Check-in today');
  });
}
