import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';

/// Helper extension used to mutate the items in the tasks list.
extension MutableTasks on Tasks {
  /// add an item to the task
  Tasks addTask(Task task) {
    final copy = List<Task>.from(tasksList);
    copy.add(task);
    return Tasks(tasksList: copy);
  }

  /// add a list of tasks to the task list
  Tasks addTasks(List<Task> tasksToAdd) {
    final copy = List<Task>.from(tasksList);
    for (Task task in tasksToAdd) {
      copy.add(task);
    }
    return Tasks(tasksList: copy);
  }

  /// if the task is found, remove it
  Tasks removeTask(Task task) {
    final copy = List<Task>.from(tasksList);
    copy.remove(task);
    return Tasks(tasksList: copy);
  }
}
