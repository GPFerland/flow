import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/src/features/authentication/data/auth_repository.dart';
import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_creation_queue.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/tasks/domain/mutable_task.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/date.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'task_instances_service.g.dart';

class TaskInstancesService {
  TaskInstancesService({
    required this.authRepository,
    required this.dateRepository,
    required this.localTaskInstancesRepository,
    required this.remoteTaskInstancesRepository,
    required this.taskInstancesCreationQueue,
  });

  final FirebaseAuth authRepository;
  final DateRepository dateRepository;
  final LocalTaskInstancesRepository localTaskInstancesRepository;
  final RemoteTaskInstancesRepository remoteTaskInstancesRepository;
  // queue is required because a user could swipe eratically and cause
  // a duplicated task instance if the remote repository responds slowly
  final TaskInstancesCreationQueue taskInstancesCreationQueue;

  // * create
  Future<void> createTaskInstance(TaskInstance taskInstance) async {
    final user = authRepository.currentUser;
    if (user == null) {
      await localTaskInstancesRepository.createTaskInstance(
        taskInstance,
      );
    } else {
      await remoteTaskInstancesRepository.createTaskInstance(
        user.uid,
        taskInstance,
      );
    }
  }

  Future<void> createTaskInstances(List<TaskInstance> taskInstances) async {
    final user = authRepository.currentUser;

    // filter out any task instances already in the queue
    final filteredTaskInstances = taskInstances
        .where(
          (taskInstance) => !taskInstancesCreationQueue.contains(taskInstance),
        )
        .toList();

    taskInstancesCreationQueue.addAll(filteredTaskInstances);

    if (user == null) {
      // create in local repository
      await localTaskInstancesRepository
          .createTaskInstances(filteredTaskInstances)
          .then((_) {
        // remove from the queue
        taskInstancesCreationQueue.removeAll(filteredTaskInstances);
      });
    } else {
      // create in remote repository
      await remoteTaskInstancesRepository
          .createTaskInstances(user.uid, filteredTaskInstances)
          .then((_) {
        // remove from the queue
        taskInstancesCreationQueue.removeAll(filteredTaskInstances);
      });
    }
  }

  Future<void> createTasksInstances(Task task, List<DateTime> dates) async {
    List<TaskInstance> newTaskInstances = List.empty(growable: true);
    // creates a task instance for the task on each date in the dates list
    for (DateTime date in dates) {
      // if the task was created on or after the date
      if (!date.isBefore(task.createdOn) &&
          // and the task is scheduled on the date
          task.isScheduled(date) &&
          // and a task instance does not exists for the task on the date
          !await _taskInstanceExists(task: task, date: date)) {
        // then create a new task instance for the date
        newTaskInstances.add(
          TaskInstance(
            id: const Uuid().v4(),
            taskId: task.id,
            taskPriority: task.priority,
            untilAddressed: task.untilAddressed,
            scheduledDate: date,
            nextScheduledDate: task.nextScheduledDate(date),
          ),
        );
      }
    }
    if (newTaskInstances.isNotEmpty) {
      await createTaskInstances(newTaskInstances);
    }
  }

  // * read
  // all read functionality is handled by providers (defined below)

  // * update
  Future<void> updateTaskInstance(TaskInstance taskInstance) async {
    final user = authRepository.currentUser;
    if (user == null) {
      await localTaskInstancesRepository.updateTaskInstance(taskInstance);
    } else {
      await remoteTaskInstancesRepository.updateTaskInstance(
          user.uid, taskInstance);
    }
  }

  Future<void> updateTaskInstances(List<TaskInstance> taskInstances) async {
    final user = authRepository.currentUser;
    if (user == null) {
      await localTaskInstancesRepository.updateTaskInstances(taskInstances);
    } else {
      await remoteTaskInstancesRepository.updateTaskInstances(
        user.uid,
        taskInstances,
      );
    }
  }

  //todo - this function should probably only take the tasks that
  // have actually had their priority changed, right now it just takes all the
  // tasks and that works but not for long
  Future<void> updateTaskInstancesPriority(List<Task> tasks) async {
    final dbTaskInstances = await _fetchTaskInstances();
    final List<TaskInstance> updatedTaskInstances = List.empty(growable: true);
    for (TaskInstance taskInstance in dbTaskInstances) {
      // if the task instance scheduledDate is before today
      if (taskInstance.scheduledDate.isBefore(getDateNoTimeToday())) {
        // then it does not need to be updated
        // we want to preserve historical order so a change to a task priority
        // should not change the priority of a task instance that was addressed
        // in the past
        continue;
      }
      Task? task = tasks.firstWhereOrNull(
        (task) => task.id == taskInstance.taskId,
      );
      //todo - raise an error if task is null here
      if (task != null) {
        updatedTaskInstances.add(taskInstance.setTaskPriority(task.priority));
      }
    }
    await updateTaskInstances(updatedTaskInstances);
  }

  // * delete
  Future<void> deleteTaskInstance(String taskInstanceId) async {
    final user = authRepository.currentUser;
    if (user == null) {
      await localTaskInstancesRepository.deleteTaskInstance(taskInstanceId);
    } else {
      await remoteTaskInstancesRepository.deleteTaskInstance(
        user.uid,
        taskInstanceId,
      );
    }
  }

  Future<void> deleteTaskInstances(List<String> taskInstanceIds) async {
    final user = authRepository.currentUser;
    if (user == null) {
      await localTaskInstancesRepository.deleteTaskInstances(taskInstanceIds);
    } else {
      await remoteTaskInstancesRepository.deleteTaskInstances(
        user.uid,
        taskInstanceIds,
      );
    }
  }

  /// deletes all task instances associated with the provided taskId
  Future<void> deleteTasksInstances(String taskId) async {
    final dbTaskInstances = await _fetchTaskInstances();
    final matchingTaskInstanceIds = dbTaskInstances
        // find the task instances that match the taskId
        .where(
          (dbTaskInstance) => dbTaskInstance.taskId == taskId,
        )
        // then collect the id of each matching task instance
        .map(
          (taskInstance) => taskInstance.id,
        )
        .toList();
    await deleteTaskInstances(matchingTaskInstanceIds);
  }

  // * helper functions
  Future<List<TaskInstance>> _fetchTaskInstances() async {
    List<TaskInstance> dbTaskInstances = List.empty(growable: true);
    final user = authRepository.currentUser;
    if (user == null) {
      dbTaskInstances = await localTaskInstancesRepository.fetchTaskInstances();
    } else {
      dbTaskInstances = await remoteTaskInstancesRepository.fetchTaskInstances(
        user.uid,
      );
    }
    return dbTaskInstances;
  }

  Future<bool> _taskInstanceExists({
    required Task task,
    required DateTime date,
  }) async {
    final dbTaskInstances = await _fetchTaskInstances();
    // find task instances that match the tasks id
    final matchingTaskInstances = dbTaskInstances
        .where((taskInstance) => taskInstance.taskId == task.id)
        .toList();
    // for each matching task instance
    for (TaskInstance taskInstance in matchingTaskInstances) {
      // if the date is the same as any of the taskInstance dates
      if (date == taskInstance.scheduledDate ||
          date == taskInstance.rescheduledDate ||
          date == taskInstance.completedDate ||
          date == taskInstance.skippedDate) {
        // then a matching task instance exists for that date
        return true;
      }
    }
    // check the queue
    return false;
  }

  //todo - these functions are fucked
  // update the existing task instances for the task
  Future<void> changeTasksInstances(Task task, Task? oldTask) async {
    if (oldTask == null) {
      await createTasksInstances(
        task,
        [
          dateRepository.dateBefore,
          dateRepository.date,
          dateRepository.dateAfter,
        ],
      );
    } else {
      await changeTaskInstances(task, oldTask);
    }
  }

  Future<void> changeTaskInstances(Task task, Task oldTask) async {
    bool frequencyChanged = task.frequency != oldTask.frequency;
    bool untilAddressedChanged = task.untilAddressed != oldTask.untilAddressed;
    if (!frequencyChanged && !untilAddressedChanged) {
      switch (task.frequency) {
        case Frequency.once:
          if (task.date == oldTask.date) return;
          break;
        case Frequency.daily:
          return;
        case Frequency.weekly:
          if (task.weekdays == oldTask.weekdays) return;
          break;
        case Frequency.monthly:
          if (task.monthdays == oldTask.monthdays) return;
          break;
      }
    }

    final dbTaskInstances = await _fetchTaskInstances();

    final taskInstanceIdsToDelete = dbTaskInstances
        .where((taskInstance) {
          if (taskInstance.taskId == task.id &&
              taskInstance.scheduledDate.isAfter(getDateNoTimeYesterday())) {
            return true;
          }
          return false;
        })
        .map((taskInstance) => taskInstance.id)
        .toList();

    await deleteTaskInstances(taskInstanceIdsToDelete);
    await createTasksInstances(
      task,
      [
        dateRepository.dateBefore,
        dateRepository.date,
        dateRepository.dateAfter,
      ],
    );
  }
}

@Riverpod(keepAlive: true)
TaskInstancesService taskInstancesService(TaskInstancesServiceRef ref) {
  return TaskInstancesService(
    authRepository: ref.watch(
      authRepositoryProvider,
    ),
    dateRepository: ref.watch(
      dateRepositoryProvider,
    ),
    localTaskInstancesRepository: ref.watch(
      localTaskInstancesRepositoryProvider,
    ),
    remoteTaskInstancesRepository: ref.watch(
      remoteTaskInstancesRepositoryProvider,
    ),
    taskInstancesCreationQueue: ref.watch(
      taskInstancesCreationQueueProvider,
    ),
  );
}

@riverpod
Stream<List<TaskInstance>> dateTaskInstancesStream(
  DateTaskInstancesStreamRef ref,
  DateTime date,
) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return ref.watch(localTaskInstancesRepositoryProvider).watchTaskInstances(
          date,
        );
  } else {
    return ref.watch(remoteTaskInstancesRepositoryProvider).watchTaskInstances(
          user.uid,
          date,
        );
  }
}
