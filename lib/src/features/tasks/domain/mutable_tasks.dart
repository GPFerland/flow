import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';

/// Helper extension used to mutate the items in the tasks list.
extension MutableTasks on Tasks {
  /// add a task
  Tasks addTask(Task task) {
    final copy = List<Task>.from(tasksList);
    copy.add(task);
    return Tasks(tasksList: copy);
  }

  /// add a list of tasks
  Tasks addTasks(List<Task> tasksToAdd) {
    final copy = List<Task>.from(tasksList);
    for (Task task in tasksToAdd) {
      copy.add(task);
    }
    return Tasks(tasksList: copy);
  }

  /// set task if a match exists or create new task
  Tasks setTask(Task task) {
    final copy = List<Task>.from(tasksList);
    final index = copy.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      copy[index] = task;
    } else {
      copy.add(task);
    }
    return Tasks(tasksList: copy);
  }

  /// remove task if it exists
  Tasks removeTask(Task task) {
    final copy = List<Task>.from(tasksList);
    copy.remove(task);
    return Tasks(tasksList: copy);
  }
}
