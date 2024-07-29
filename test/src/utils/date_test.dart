@Timeout(Duration(milliseconds: 500))
library;

import 'package:flow/src/utils/date.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('getFormattedDateString', () {
    test('date is today, returns "Today"', () {
      // setup
      final date = DateTime.now();
      // run
      final result = getFormattedDateString(date);
      // verify
      expect(result, 'Today');
    });

    test('date is tomorrow, returns "Tomorrow"', () {
      // setup
      final date = DateTime.now().add(const Duration(days: 1));
      // run
      final result = getFormattedDateString(date);
      // verify
      expect(result, 'Tomorrow');
    });

    test('date is yesterday, returns "Yesterday"', () {
      // setup
      final date = DateTime.now().subtract(const Duration(days: 1));
      // run
      final result = getFormattedDateString(date);
      // verify
      expect(result, 'Yesterday');
    });

    test("""date is NOT today, tomorrow, or yesterday,
            returns date in "E, MMM d" format, i.e. Mon, Jan 1""", () {
      // setup
      final date = DateTime.now().subtract(const Duration(days: 3));
      final dateFormatter = DateFormat('E, MMM d');
      // run
      final result = getFormattedDateString(date);
      // verify
      expect(result, dateFormatter.format(date));
    });
  });

  group('getDate* functions', () {
    test('getDateNoTime - returns date, no time data', () {
      // setup
      final date = DateTime.now();
      // run
      final result = getDateNoTime(date);
      // verify
      expect(result, DateTime(date.year, date.month, date.day));
    });

    test('getDateNoTimeToday - returns todays date, no time data', () {
      // setup
      final today = DateTime.now();
      // run
      final result = getDateNoTimeToday();
      // verify
      expect(result, DateTime(today.year, today.month, today.day));
    });

    test('getDateNoTimeYesterday - returns yesterdays date, no time data', () {
      // setup
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      // run
      final result = getDateNoTimeYesterday();
      // verify
      expect(result, DateTime(yesterday.year, yesterday.month, yesterday.day));
    });

    test('getDateNoTimeTomorrow - returns tomorrows date, no time data', () {
      // setup
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      // run
      final result = getDateNoTimeTomorrow();
      // verify
      expect(result, DateTime(tomorrow.year, tomorrow.month, tomorrow.day));
    });
  });

  group('monthdayMatch', () {
    test('monthday does match date, returns true', () {
      // setup
      final today = DateTime.now();
      final lastDayOfMonth = DateTime(today.year, today.month + 1, 0);
      final List<Map<String, dynamic>> pairs = [
        {
          'monthday': const Monthday(
            ordinal: Ordinal.first,
            weekday: Weekday.day,
          ),
          'date': DateTime(today.year, today.month, 1),
        },
        {
          'monthday': const Monthday(
            ordinal: Ordinal.second,
            weekday: Weekday.day,
          ),
          'date': DateTime(today.year, today.month, 2),
        },
        {
          'monthday': const Monthday(
            ordinal: Ordinal.third,
            weekday: Weekday.day,
          ),
          'date': DateTime(today.year, today.month, 3),
        },
        {
          'monthday': const Monthday(
            ordinal: Ordinal.fourth,
            weekday: Weekday.day,
          ),
          'date': DateTime(today.year, today.month, 4),
        },
        {
          'monthday': const Monthday(
            ordinal: Ordinal.fifth,
            weekday: Weekday.day,
          ),
          'date': DateTime(today.year, today.month, 5),
        },
        {
          'monthday': const Monthday(
            ordinal: Ordinal.last,
            weekday: Weekday.day,
          ),
          'date': lastDayOfMonth,
        },
        {
          'monthday': const Monthday(
            ordinal: Ordinal.first,
            weekday: Weekday.sun,
          ),
          'date': addTillWeekday(
            date: DateTime(today.year, today.month, 1),
            weekdayIndex: Weekday.sun.weekdayIndex,
          ),
        },
        {
          'monthday': const Monthday(
            ordinal: Ordinal.second,
            weekday: Weekday.sun,
          ),
          'date': addTillWeekday(
            date: DateTime(today.year, today.month, 1),
            weekdayIndex: Weekday.sun.weekdayIndex,
            occurrenceNum: 2,
          ),
        },
        {
          'monthday': const Monthday(
            ordinal: Ordinal.third,
            weekday: Weekday.sun,
          ),
          'date': addTillWeekday(
            date: DateTime(today.year, today.month, 1),
            weekdayIndex: Weekday.sun.weekdayIndex,
            occurrenceNum: 3,
          ),
        },
        {
          'monthday': const Monthday(
            ordinal: Ordinal.fourth,
            weekday: Weekday.sun,
          ),
          'date': addTillWeekday(
            date: DateTime(today.year, today.month, 1),
            weekdayIndex: Weekday.sun.weekdayIndex,
            occurrenceNum: 4,
          ),
        },
        {
          'monthday': const Monthday(
            ordinal: Ordinal.last,
            weekday: Weekday.sun,
          ),
          'date': subtractTillWeekday(
            date: lastDayOfMonth,
            weekdayIndex: Weekday.sun.weekdayIndex,
          ),
        },
      ];
      for (final pair in pairs) {
        final monthday = pair['monthday'] as Monthday;
        final date = pair['date'] as DateTime;

        // run
        final result = monthdayMatch(monthday, date);

        // verify
        expect(result, true);
      }
    });

    test('monthday does NOT match date, returns false', () {
      // setup
      final today = DateTime.now();
      final List<Map<String, dynamic>> pairs = [
        {
          'monthday': const Monthday(
            ordinal: Ordinal.first,
            weekday: Weekday.day,
          ),
          'date': DateTime(today.year, today.month, 3),
        },
        {
          'monthday': const Monthday(
            ordinal: Ordinal.last,
            weekday: Weekday.day,
          ),
          'date': DateTime(today.year, today.month, 1),
        },
        {
          'monthday': const Monthday(
            ordinal: Ordinal.first,
            weekday: Weekday.sun,
          ),
          'date': addTillWeekday(
            date: DateTime(today.year, today.month, 1),
            weekdayIndex: Weekday.sun.weekdayIndex,
            occurrenceNum: 3,
          ),
        },
        {
          'monthday': const Monthday(
            ordinal: Ordinal.last,
            weekday: Weekday.sun,
          ),
          'date': DateTime(today.year, today.month, 1),
        },
      ];
      for (final pair in pairs) {
        final monthday = pair['monthday'] as Monthday;
        final date = pair['date'] as DateTime;

        // run
        final result = monthdayMatch(monthday, date);

        // verify
        expect(result, false);
      }
    });
  });

  group('addTillWeekday', () {
    test('returns correct date', () {
      // setup
      final today = DateTime.now();
      final firstOfTheMonth = DateTime(today.year, today.month, 1);
      final firstWeekday = Weekday.values.firstWhere(
        (weekday) => weekday.weekdayIndex == firstOfTheMonth.weekday,
      );
      // run
      final result = addTillWeekday(
          date: firstOfTheMonth,
          weekdayIndex: firstWeekday.weekdayIndex == Weekday.sun.weekdayIndex
              ? Weekday.mon.weekdayIndex
              : firstWeekday.weekdayIndex + 1,
          occurrenceNum: 2);
      // verify
      expect(result.weekday, firstWeekday.weekdayIndex + 1);
    });
  });

  group('subtractTillWeekday', () {
    test('returns correct date', () {
      // setup
      final today = DateTime.now();
      final lastOfTheMonth = DateTime(today.year, today.month + 1, 0);
      final lastWeekday = Weekday.values.firstWhere(
        (weekday) => weekday.weekdayIndex == lastOfTheMonth.weekday,
      );
      // run
      final result = addTillWeekday(
          date: lastOfTheMonth,
          weekdayIndex: lastWeekday.weekdayIndex == Weekday.mon.weekdayIndex
              ? Weekday.sun.weekdayIndex
              : lastWeekday.weekdayIndex - 1,
          occurrenceNum: 2);
      // verify
      expect(result.weekday, lastWeekday.weekdayIndex - 1);
    });
  });
}
