import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_instances_creation_queue.g.dart';

class TaskInstancesCreationQueue {
  TaskInstancesCreationQueue();

  final queue = Queue<TaskInstance>();

  void add(TaskInstance taskInstance) {
    queue.add(taskInstance);
  }

  void addAll(List<TaskInstance> taskInstances) {
    queue.addAll(taskInstances);
  }

  bool contains(TaskInstance taskInstance) {
    // search the queue for a task instance
    final match = queue.firstWhereOrNull((queueTaskInstance) {
      // if the taskId is the same
      if (taskInstance.taskId == queueTaskInstance.taskId &&
          // and the scheduledDate is the same
          taskInstance.scheduledDate == queueTaskInstance.scheduledDate) {
        return true;
      }
      return false;
    });
    return match == null ? false : true;
  }

  void remove(TaskInstance taskInstance) {
    queue.removeWhere(
      (queueTaskInstance) {
        // if the taskId is the same
        if (taskInstance.taskId == queueTaskInstance.taskId &&
            // and the scheduledDate is the same
            taskInstance.scheduledDate == queueTaskInstance.scheduledDate) {
          return true;
        }
        return false;
      },
    );
  }

  void removeAll(List<TaskInstance> taskInstances) {
    for (TaskInstance taskInstance in taskInstances) {
      remove(taskInstance);
    }
  }
}

@Riverpod(keepAlive: true)
TaskInstancesCreationQueue taskInstancesCreationQueue(
  TaskInstancesCreationQueueRef ref,
) {
  return TaskInstancesCreationQueue();
}
