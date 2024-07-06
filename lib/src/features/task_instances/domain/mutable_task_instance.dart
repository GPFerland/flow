import 'package:flow/src/features/task_instances/domain/task_instance.dart';

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
}
