import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';

/// Helper extension used to mutate the items in the taskInstances list.
extension MutableTaskInstances on TaskInstances {
  /// add a task instance
  TaskInstances addTaskInstance(TaskInstance taskInstance) {
    final copy = List<TaskInstance>.from(taskInstancesList);
    copy.add(taskInstance);
    return TaskInstances(taskInstancesList: copy);
  }

  /// add a list of task instances
  TaskInstances addTaskInstances(List<TaskInstance> taskInstancesToAdd) {
    final copy = List<TaskInstance>.from(taskInstancesList);
    for (TaskInstance taskInstance in taskInstancesToAdd) {
      copy.add(taskInstance);
    }
    return TaskInstances(taskInstancesList: copy);
  }

  /// set task instance if a match exists or create new task instance
  TaskInstances setTaskInstance(TaskInstance taskInstance) {
    final copy = List<TaskInstance>.from(taskInstancesList);
    final index = copy.indexWhere((t) => t.id == taskInstance.id);
    if (index != -1) {
      copy[index] = taskInstance;
    } else {
      copy.add(taskInstance);
    }
    return TaskInstances(taskInstancesList: copy);
  }

  /// remote task instance if it exists
  TaskInstances removeTaskInstance(TaskInstance taskInstance) {
    final copy = List<TaskInstance>.from(taskInstancesList);
    copy.remove(taskInstance);
    return TaskInstances(taskInstancesList: copy);
  }

  /// remove all task instances with a matching task id
  TaskInstances removeTasksInstances(String taskId) {
    final copy = List<TaskInstance>.from(taskInstancesList);
    final loopCopy = List<TaskInstance>.from(taskInstancesList);
    for (final taskInstance in loopCopy) {
      if (taskInstance.taskId == taskId) {
        copy.remove(taskInstance);
      }
    }
    return TaskInstances(taskInstancesList: copy);
  }

  /// sort the task instances,
  /// first NON-completed and NON-skipped task instances
  /// then complteted task instances
  /// then skipped task instances
  TaskInstances sortTaskInstances() {
    final copy = List<TaskInstance>.from(taskInstancesList);
    copy.sort((a, b) {
      int aWeight = a.skipped ? 2 : (a.completed ? 1 : 0);
      int bWeight = b.skipped ? 2 : (b.completed ? 1 : 0);
      return aWeight.compareTo(bWeight);
    });
    return TaskInstances(taskInstancesList: copy);
  }
}
