import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/date.dart';

/// Helper extension used to mutate the fields in a taskInstance object.
extension MutableTask on Task {
  /// set the task priority
  Task setPriority(int newPriority) {
    return copyWith(
      priority: newPriority,
    );
  }

  String get frequencyText {
    switch (frequency) {
      case Frequency.once:
        return getFormattedDateString(date);
      case Frequency.daily:
        return 'Everyday';
      case Frequency.weekly:
        return _getWeeklyFrequencyText();
      case Frequency.monthly:
        return _getMonthlyFrequencyText();
      default:
        return getFormattedDateString(date);
    }
  }

  String _getWeeklyFrequencyText() {
    if (weekdays.isEmpty) {
      return 'No days selected';
    } else {
      weekdays.sort((a, b) => a.weekdayIndex.compareTo(b.weekdayIndex));
      if (weekdays.length == Weekday.values.length - 1) {
        return 'Everyday';
      } else if (weekdays.length == 2) {
        return weekdays
            .map((weekday) => weekday.shorthand)
            .toList()
            .join(' & ');
      }
      return weekdays.map((weekday) => weekday.shorthand).toList().join(', ');
    }
  }

  String _getMonthlyFrequencyText() {
    if (monthdays.isEmpty) {
      return 'No days selected';
    } else if (monthdays.length == 1) {
      return '${monthdays[0].ordinal.longhand} ${monthdays[0].weekday.longhand} of the Month';
    }
    return 'Multiple days a month';
  }

  bool isScheduled({required DateTime currentDate}) {
    switch (frequency) {
      case Frequency.once:
        if (date == currentDate) {
          return true;
        }
      case Frequency.daily:
        return true;
      case Frequency.weekly:
        for (Weekday weekday in weekdays) {
          if (weekday.weekdayIndex == currentDate.weekday) {
            return true;
          }
        }
      case Frequency.monthly:
        for (Monthday monthday in monthdays) {
          if (monthdayMatch(monthday, currentDate)) {
            return true;
          }
        }
    }
    return false;
  }

  DateTime? nextScheduledDate(DateTime currentDate) {
    switch (frequency) {
      case Frequency.once:
        return null;
      case Frequency.daily:
        return currentDate.add(const Duration(days: 1));
      case Frequency.weekly:
        if (weekdays.isEmpty) {
          return null;
        }
        DateTime loopDate =
            getDateNoTime(currentDate).add(const Duration(days: 1));
        for (int i = 1; i <= 7; i++) {
          if (weekdays
              .any((weekday) => weekday.weekdayIndex == loopDate.weekday)) {
            return loopDate;
          }
          loopDate = loopDate.add(const Duration(days: 1));
        }
      case Frequency.monthly:
        if (weekdays.isEmpty) {
          return null;
        }
        DateTime loopDate =
            getDateNoTime(currentDate).add(const Duration(days: 1));
        for (int i = 1; i <= 31; i++) {
          if (monthdays.any((monthday) => monthdayMatch(monthday, loopDate))) {
            return loopDate;
          }
          loopDate = loopDate.add(const Duration(days: 1));
        }
    }
    return null;
  }
}
