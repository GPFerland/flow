import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/date.dart';

/// Helper extension used to mutate the fields in a taskInstance object.
extension MutableTaskInstance on TaskInstance {
  TaskInstance reschedule(DateTime rescheduledDate) {
    return copyWith(
      rescheduledDate: () => rescheduledDate,
      completedDate: () => completedDate != null ? rescheduledDate : null,
      skippedDate: () => skippedDate != null ? rescheduledDate : null,
    );
  }

  TaskInstance toggleCompleted(DateTime date) {
    if (completed) {
      return copyWith(completed: false, completedDate: () => null);
    } else {
      return copyWith(completed: true, completedDate: () => date);
    }
  }

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
    if (isScheduled(date) ||
        // only display a task instance that isOverdue if the date is today
        (date == getDateNoTimeToday() && isOverdue(date)) ||
        isAddressed(date)) {
      return true;
    }
    return false;
  }

  bool isScheduled(DateTime date) {
    if ((date == scheduledDate && rescheduledDate == null) ||
        date == rescheduledDate) {
      return true;
    }
    return false;
  }

  bool isOverdue(DateTime date) {
    // if the task instance should be shown until it is completed or skipped
    if (untilAddressed &&
        // and the date is past the scheduledDate
        scheduledDate.isBefore(date) &&
        // and the rescheduledDate is null or date is past rescheduledDate
        (rescheduledDate == null || rescheduledDate!.isBefore(date)) &&
        // and the nextScheduledDate is null or date is before nextScheduledDate
        (nextScheduledDate == null || date.isBefore(nextScheduledDate!)) &&
        // and the task instance is not addressed on the date
        !isAddressed(date)) {
      // then the task instance is overdue
      return true;
    }
    return false;
  }

  // * return true if the task instance was either completed or skipped on date
  bool isAddressed(DateTime date) {
    if (((completed && date == completedDate) ||
        (skipped && date == skippedDate))) {
      return true;
    }
    return false;
  }
}
