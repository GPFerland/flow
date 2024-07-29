import 'package:flow/src/features/tasks/domain/mutable_task.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils.dart';

void main() {
  group('setPriority', () {
    test('priority is set to the new value', () {
      // setup
      final task = createTestTask();
      const priority = 10;
      expect(task.priority, 0);
      // run
      final updatedTaskInstance = task.setPriority(priority);
      // verify
      expect(updatedTaskInstance.priority, priority);
    });
  });

  group('frequencyText', () {
    test('once frequency', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.once,
      );
      final expectedFrequencyText = getFormattedDateString(
        getDateNoTimeToday(),
      );
      // run & verify
      expect(task.frequencyText, expectedFrequencyText);
    });
    test('daily frequency', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.daily,
      );
      const expectedFrequencyText = 'Everyday';
      // run & verify
      expect(task.frequencyText, expectedFrequencyText);
    });
    test('weekly frequency, no days selected', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.weekly,
        weekdays: [],
      );
      const expectedFrequencyText = 'No days selected';
      // run & verify
      expect(task.frequencyText, expectedFrequencyText);
    });
    test('weekly frequency, one day', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.weekly,
        weekdays: [Weekday.sun],
      );
      final expectedFrequencyText = Weekday.sun.shorthand;
      // run & verify
      expect(task.frequencyText, expectedFrequencyText);
    });
    test('weekly frequency, two days', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.weekly,
        weekdays: [Weekday.sun, Weekday.wed],
      );
      //todo - we should probably test the order of how this shit is displayed??
      final expectedFrequencyText =
          '${Weekday.wed.shorthand} & ${Weekday.sun.shorthand}';
      // run & verify
      expect(task.frequencyText, expectedFrequencyText);
    });
    test('weekly frequency, every day', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.weekly,
        weekdays: [
          Weekday.sun,
          Weekday.mon,
          Weekday.tue,
          Weekday.wed,
          Weekday.thu,
          Weekday.fri,
          Weekday.sat,
        ],
      );
      const expectedFrequencyText = 'Everyday';
      // run & verify
      expect(task.frequencyText, expectedFrequencyText);
    });
    test('monthly frequency, no days selected', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.monthly,
        monthdays: [],
      );
      const expectedFrequencyText = 'No days selected';
      // run & verify
      expect(task.frequencyText, expectedFrequencyText);
    });
    test('monthly frequency, one day selected', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.monthly,
        monthdays: [
          const Monthday(
            weekday: Weekday.day,
            ordinal: Ordinal.first,
          )
        ],
      );
      final expectedFrequencyText =
          '${Ordinal.first.longhand} ${Weekday.day.longhand} of the month';
      // run & verify
      expect(task.frequencyText, expectedFrequencyText);
    });
    test('monthly frequency, more than one day selected', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.monthly,
        monthdays: [
          const Monthday(
            weekday: Weekday.day,
            ordinal: Ordinal.first,
          ),
          const Monthday(
            weekday: Weekday.tue,
            ordinal: Ordinal.second,
          )
        ],
      );
      const expectedFrequencyText = 'Multiple days a month';
      // run & verify
      expect(task.frequencyText, expectedFrequencyText);
    });
  });

  group('isScheduled', () {
    test('once frequency, scheduled', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.once,
        date: getDateNoTimeToday(),
      );
      // run & verify
      expect(
        task.isScheduled(getDateNoTimeToday()),
        true,
      );
    });
    test('once frequency, NOT scheduled', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.once,
        date: getDateNoTimeTomorrow(),
      );
      // run & verify
      expect(
        task.isScheduled(getDateNoTimeToday()),
        false,
      );
    });
    test('daily frequency, scheduled', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.daily,
      );
      // run & verify
      expect(task.isScheduled(getDateNoTimeToday()), true);
    });
    test('weekly frequency, scheduled', () {
      // setup
      final nextSunday = addTillWeekday(
        date: getDateNoTimeToday(),
        weekdayIndex: Weekday.sun.weekdayIndex,
      );
      final task = createTestTask().copyWith(
        frequency: Frequency.weekly,
        weekdays: [Weekday.sun],
      );
      // run & verify
      expect(task.isScheduled(nextSunday), true);
    });
    test('weekly frequency, NOT scheduled', () {
      // setup
      final nextSunday = addTillWeekday(
        date: getDateNoTimeToday(),
        weekdayIndex: Weekday.sun.weekdayIndex,
      );
      final task = createTestTask().copyWith(
        frequency: Frequency.weekly,
        weekdays: [Weekday.wed],
      );
      // run & verify
      expect(task.isScheduled(nextSunday), false);
    });
    test('monthly frequency, scheduled', () {
      // setup
      final today = DateTime.now();
      final firstOfTheMonth = DateTime(today.year, today.month, 1);
      final task = createTestTask().copyWith(
        frequency: Frequency.monthly,
        monthdays: [
          const Monthday(
            weekday: Weekday.day,
            ordinal: Ordinal.first,
          )
        ],
      );
      // run & verify
      expect(task.isScheduled(firstOfTheMonth), true);
    });
    test('monthly frequency, NOT scheduled', () {
      // setup
      final today = DateTime.now();
      final fifthOfTheMonth = DateTime(today.year, today.month, 5);
      final task = createTestTask().copyWith(
        frequency: Frequency.monthly,
        monthdays: [
          const Monthday(
            weekday: Weekday.day,
            ordinal: Ordinal.first,
          )
        ],
      );
      // run & verify
      expect(task.isScheduled(fifthOfTheMonth), false);
    });
  });

  group('nextScheduledDate', () {
    test('once frequency', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.once,
        date: getDateNoTimeToday(),
      );
      // run & verify
      expect(
        task.nextScheduledDate(getDateNoTimeToday()),
        null,
      );
    });
    test('daily frequency', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.daily,
      );
      // run & verify
      expect(
        task.nextScheduledDate(getDateNoTimeToday()),
        getDateNoTimeTomorrow(),
      );
    });
    test('weekly frequency, no days selected', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.weekly,
        weekdays: [],
      );
      // run & verify
      expect(
        task.nextScheduledDate(getDateNoTimeToday()),
        null,
      );
    });
    test('weekly frequency', () {
      // setup
      final nextSunday = addTillWeekday(
        date: getDateNoTimeToday(),
        weekdayIndex: Weekday.sun.weekdayIndex,
      );
      final task = createTestTask().copyWith(
        frequency: Frequency.weekly,
        weekdays: [Weekday.sun],
      );
      // run & verify
      expect(
        task.nextScheduledDate(getDateNoTimeToday()),
        nextSunday,
      );
    });
    test('monthly frequency, no days selected', () {
      // setup
      final task = createTestTask().copyWith(
        frequency: Frequency.monthly,
        monthdays: [],
      );
      // run & verify
      expect(
        task.nextScheduledDate(getDateNoTimeToday()),
        null,
      );
    });
    test('monthly frequency', () {
      // setup
      final today = getDateNoTimeToday();
      final firstOfNextMonth = DateTime(today.year, today.month + 1, 1);
      final task = createTestTask().copyWith(
        frequency: Frequency.monthly,
        monthdays: [
          const Monthday(
            weekday: Weekday.day,
            ordinal: Ordinal.first,
          )
        ],
      );
      // run & verify
      expect(task.nextScheduledDate(today), firstOfNextMonth);
    });
  });
}
