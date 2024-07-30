import 'package:collection/collection.dart';
import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/check_list/data/date_repository.dart';
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
  });

  final TestAuthRepository authRepository;
  final DateRepository dateRepository;
  final LocalTaskInstancesRepository localTaskInstancesRepository;
  final RemoteTaskInstancesRepository remoteTaskInstancesRepository;

  /// save the task instances to the local or remote repository
  /// depending on the user auth state
  Future<void> _setTaskInstances(List<TaskInstance> taskInstances) async {
    final user = authRepository.currentUser;
    if (user == null) {
      await localTaskInstancesRepository.setTaskInstances(
        taskInstances,
      );
    } else {
      await remoteTaskInstancesRepository.setTaskInstances(
        user.uid,
        taskInstances,
      );
    }
  }

  /// fetch the task instances from the local or remote repository
  /// depending on the user auth state
  Future<List<TaskInstance>> _fetchTaskInstances() {
    final user = authRepository.currentUser;
    if (user == null) {
      return localTaskInstancesRepository.fetchTaskInstances();
    } else {
      return remoteTaskInstancesRepository.fetchTaskInstances(user.uid);
    }
  }

  /// sets a list of task instances
  Future<void> setTaskInstances(List<TaskInstance> taskInstances) async {
    final dbTaskInstances = await _fetchTaskInstances();

    for (TaskInstance taskInstance in taskInstances) {
      final index = dbTaskInstances.indexWhere(
        (dbTaskInstance) => dbTaskInstance.id == taskInstance.id,
      );
      if (index == -1) {
        dbTaskInstances.add(taskInstance);
      } else {
        dbTaskInstances[index] = taskInstance;
      }
    }

    await _setTaskInstances(dbTaskInstances);
  }

  // creates a task instance for the task on each date in the dates list
  // if the task is scheduled for the date
  // and there is not an existing task instance for the task on the date
  Future<void> createTaskInstances(Task task, List<DateTime> dates) async {
    List<TaskInstance> newTaskInstances = List.empty(growable: true);

    for (DateTime date in dates) {
      if (date.isBefore(task.createdOn) ||
          !task.isScheduled(date) ||
          await _taskInstanceExists(task: task, date: date)) {
        continue;
      }

      newTaskInstances.add(
        TaskInstance(
          id: const Uuid().v4(),
          taskId: task.id,
          taskPriority: task.priority,
          untilCompleted: task.untilCompleted,
          nextInstanceOn: task.nextScheduledDate(date),
          initialDate: date,
        ),
      );
    }

    if (newTaskInstances.isNotEmpty) {
      await setTaskInstances(newTaskInstances);
    }
  }

  Future<bool> _taskInstanceExists({
    required Task task,
    required DateTime date,
  }) async {
    final taskInstances = await _fetchTaskInstances();

    final filteredTaskInstances = taskInstances
        .where((taskInstance) => taskInstance.taskId == task.id)
        .toList();

    for (TaskInstance taskInstance in filteredTaskInstances) {
      if (date == taskInstance.completedDate ||
          date == taskInstance.skippedDate ||
          date == taskInstance.rescheduledDate ||
          date == taskInstance.initialDate) {
        return true;
      }
    }

    return false;
  }

  /// removes a list of task instances
  Future<void> removeTaskInstances(List<TaskInstance> taskInstances) async {
    final dbTaskInstances = await _fetchTaskInstances();
    for (TaskInstance taskInstance in taskInstances) {
      dbTaskInstances.remove(taskInstance);
    }
    await _setTaskInstances(dbTaskInstances);
  }

  /// removes all task instances associated with the provided task id
  Future<void> removeTasksInstances(String taskId) async {
    final dbTaskInstances = await _fetchTaskInstances();
    dbTaskInstances.removeWhere(
      (taskInstance) => taskInstance.taskId == taskId,
    );
    await _setTaskInstances(dbTaskInstances);
  }

  // update the existing task instances for the task
  Future<void> updateTasksInstances(Task task, Task? oldTask) async {
    if (oldTask == null) {
      await createTaskInstances(
        task,
        [
          dateRepository.dateBefore,
          dateRepository.date,
          dateRepository.dateAfter,
        ],
      );
    } else {
      await updateTaskInstances(task, oldTask);
    }
  }

  Future<void> updateTaskInstances(Task task, Task oldTask) async {
    if (((task.frequency == Frequency.once &&
                oldTask.frequency == Frequency.once &&
                task.date == oldTask.date) ||
            (task.frequency == Frequency.daily &&
                oldTask.frequency == Frequency.daily) ||
            (task.frequency == Frequency.weekly &&
                oldTask.frequency == Frequency.weekly &&
                task.weekdays == oldTask.weekdays) ||
            (task.frequency == Frequency.monthly &&
                oldTask.frequency == Frequency.monthly &&
                task.monthdays == oldTask.monthdays)) &&
        (task.untilCompleted == oldTask.untilCompleted)) {
      return;
    }
    final taskInstances = await _fetchTaskInstances();
    final matchingTaskInstances = taskInstances.where((taskInstance) {
      if (taskInstance.taskId == task.id) {
        //taskInstance.initialDate.isAfter(getDateNoTimeToday()) &&
        return true;
      }
      return false;
    }).toList();

    final taskInstancesToRemove = matchingTaskInstances.where((taskInstance) {
      if (taskInstance.initialDate.isAfter(getDateNoTimeToday())) {
        return true;
      }
      return false;
    }).toList();

    await removeTaskInstances(taskInstancesToRemove);
    await createTaskInstances(
      task,
      [
        dateRepository.dateBefore,
        dateRepository.date,
        dateRepository.dateAfter,
      ],
    );
  }

  Future<void> updateTaskInstancesPriority(List<Task> tasks) async {
    final taskInstances = await _fetchTaskInstances();
    final List<TaskInstance> updatedTaskInstances = [];
    for (TaskInstance taskInstance in taskInstances) {
      if (taskInstance.initialDate.isBefore(getDateNoTimeToday())) {
        updatedTaskInstances.add(taskInstance);
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
    await _setTaskInstances(updatedTaskInstances);
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
  );
}

@riverpod
Stream<List<TaskInstance>> dateTaskInstancesStream(
  DateTaskInstancesStreamRef ref,
  DateTime date,
) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return ref
        .watch(localTaskInstancesRepositoryProvider)
        .watchTaskInstances(date: date);
  }
  return ref
      .watch(remoteTaskInstancesRepositoryProvider)
      .watchTaskInstances(user.uid, date: date);
}
