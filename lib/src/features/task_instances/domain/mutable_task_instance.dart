import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/date.dart';

/// Helper extension used to mutate the fields in a taskInstance object.
extension MutableTaskInstance on TaskInstance {
  /// reschedule the task instance to the provided date
  TaskInstance reschedule(DateTime rescheduledDate) {
    return copyWith(
      rescheduledDate: () => rescheduledDate,
      completedDate: () => completedDate != null ? rescheduledDate : null,
      skippedDate: () => skippedDate != null ? rescheduledDate : null,
    );
  }

  /// toggle the completed field of the task instance
  TaskInstance toggleCompleted(DateTime date) {
    if (completed) {
      return copyWith(completed: false, completedDate: () => null);
    } else {
      return copyWith(completed: true, completedDate: () => date);
    }
  }

  /// toggle the skipped field of the task instance
  TaskInstance toggleSkipped(DateTime date) {
    if (skipped) {
      return copyWith(skipped: false, skippedDate: () => null);
    } else {
      return copyWith(skipped: true, skippedDate: () => date);
    }
  }

  TaskInstance setTaskPriority(int taskPriority) {
    return copyWith(taskPriority: taskPriority);
  }

  bool isDisplayed(DateTime date) {
    if (isOverdue(date)) {
      return true;
    }

    if (isScheduled(date)) {
      return true;
    }

    if (untilCompleted &&
        date.isBefore(getDateNoTimeToday()) &&
        ((completed && date == completedDate) ||
            (skipped && date == skippedDate))) {
      return true;
    }

    return false;
  }

  bool isScheduled(DateTime date) {
    if ((date == initialDate && rescheduledDate == null) ||
        date == rescheduledDate) {
      return true;
    }
    return false;
  }

  bool isOverdue(DateTime date) {
    final today = getDateNoTimeToday();
    final dayBeforeNext = nextInstanceOn?.subtract(const Duration(days: 1));
    if (untilCompleted &&
        (date == today || (date.isBefore(today) && date == dayBeforeNext)) &&
        initialDate.isBefore(date) &&
        (rescheduledDate == null || rescheduledDate!.isBefore(date)) &&
        (nextInstanceOn == null || date.isBefore(nextInstanceOn!)) &&
        !completed &&
        !skipped) {
      return true;
    }
    return false;
  }
}
