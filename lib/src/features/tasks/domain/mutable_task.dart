import 'package:flow/src/features/tasks/domain/task.dart';

/// Helper extension used to mutate the fields in a taskInstance object.
extension MutableTask on Task {
  /// set the task priority
  Task setPriority(int newPriority) {
    return copyWith(
      priority: newPriority,
    );
  }
}
