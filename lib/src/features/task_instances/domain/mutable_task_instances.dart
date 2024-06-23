import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';

/// Helper extension used to mutate the items in the taskInstances list.
extension MutableTaskInstances on TaskInstances {
  /// add an item to the taskInstance
  TaskInstances addTaskInstance(TaskInstance taskInstance) {
    final copy = List<TaskInstance>.from(taskInstancesList);
    copy.add(taskInstance);
    return TaskInstances(taskInstancesList: copy);
  }

  /// add a list of taskInstances to the taskInstance list
  TaskInstances addTaskInstances(List<TaskInstance> taskInstancesToAdd) {
    final copy = List<TaskInstance>.from(taskInstancesList);
    for (TaskInstance taskInstance in taskInstancesToAdd) {
      copy.add(taskInstance);
    }
    return TaskInstances(taskInstancesList: copy);
  }

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

  /// if the taskInstance is found, remove it
  TaskInstances removeTaskInstance(TaskInstance taskInstance) {
    final copy = List<TaskInstance>.from(taskInstancesList);
    copy.remove(taskInstance);
    return TaskInstances(taskInstancesList: copy);
  }

  /// remove all task instances that have the provided task id
  TaskInstances removeTaskInstances(String taskId) {
    final copy = List<TaskInstance>.from(taskInstancesList);
    final loopCopy = List<TaskInstance>.from(taskInstancesList);
    for (final taskInstance in loopCopy) {
      if (taskInstance.taskId == taskId) {
        copy.remove(taskInstance);
      }
    }
    return TaskInstances(taskInstancesList: copy);
  }

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
