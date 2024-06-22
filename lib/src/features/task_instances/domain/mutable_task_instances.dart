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
}
