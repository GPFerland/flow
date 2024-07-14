import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/tasks/domain/mutable_task.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

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
      return await localTaskInstancesRepository.setTaskInstances(taskInstances);
    }
    await remoteTaskInstancesRepository.setTaskInstances(
      user.uid,
      taskInstances,
    );
  }

  /// fetch the task instances from the local or remote repository
  /// depending on the user auth state
  Future<List<TaskInstance>> _fetchTaskInstances() {
    final user = authRepository.currentUser;
    if (user == null) {
      return localTaskInstancesRepository.fetchTaskInstances();
    }
    return remoteTaskInstancesRepository.fetchTaskInstances(user.uid);
  }

  /// sets a task instance in the local or remote repository
  /// depending on the user auth state
  Future<void> setTaskInstance(TaskInstance taskInstance) async {
    final taskInstances = await _fetchTaskInstances();
    final index = taskInstances.indexWhere((t) => t.id == taskInstance.id);

    if (index == -1) {
      taskInstances.add(taskInstance);
    } else {
      taskInstances[index] = taskInstance;
    }

    await _setTaskInstances(taskInstances);
  }

  /// removes a list of task instances from the local or remote repository
  /// depending on the user auth state
  Future<void> removeTaskInstances(List<TaskInstance> remove) async {
    final taskInstances = await _fetchTaskInstances();
    taskInstances.removeWhere(
      (taskInstance) => remove.contains(taskInstance),
    );
    await _setTaskInstances(taskInstances);
  }

  /// removes a task instance from the local or remote repository
  /// depending on the user auth state
  Future<void> removeTaskInstance(TaskInstance taskInstance) async {
    final taskInstances = await _fetchTaskInstances();
    taskInstances.remove(taskInstance);
    await _setTaskInstances(taskInstances);
  }

  /// removes all task instances associated with the provided task id
  Future<void> removeTasksInstances(String taskId) async {
    final taskInstances = await _fetchTaskInstances();
    taskInstances.removeWhere((taskInstance) => taskInstance.taskId == taskId);
    await _setTaskInstances(taskInstances);
  }

  Future<void> updateTaskInstancesPriority(List<Task> tasks) async {
    final taskInstances = await _fetchTaskInstances();
    final List<TaskInstance> updatedTaskInstances = [];
    for (TaskInstance taskInstance in taskInstances) {
      if (taskInstance.initialDate.isBefore(getDateNoTimeToday())) {
        updatedTaskInstances.add(taskInstance);
        continue;
      }
      Task task = tasks.firstWhere((task) => task.id == taskInstance.taskId);
      updatedTaskInstances.add(taskInstance.setTaskPriority(task.priority));
    }
    await _setTaskInstances(updatedTaskInstances);
  }

  // update the existing task instances for the task
  Future<void> updateTasksInstances(Task task, Task? oldTask) async {
    if (oldTask == null) {
      await createTaskInstance(task, dateRepository.dateBefore);
      await createTaskInstance(task, dateRepository.date);
      await createTaskInstance(task, dateRepository.dateAfter);
    } else {
      await updateTaskInstances(task, oldTask);
    }
  }

  Future<void> updateTaskInstances(Task task, Task oldTask) async {
    if ((task.frequency == Frequency.once &&
            oldTask.frequency == Frequency.once &&
            task.date == oldTask.date) &&
        (task.frequency == Frequency.daily &&
            oldTask.frequency == Frequency.daily) &&
        (task.frequency == Frequency.weekly &&
            oldTask.frequency == Frequency.weekly &&
            task.weekdays == oldTask.weekdays) &&
        (task.frequency == Frequency.monthly &&
            oldTask.frequency == Frequency.monthly &&
            task.monthdays == oldTask.monthdays) &&
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
    await createTaskInstance(task, dateRepository.dateBefore);
    await createTaskInstance(task, dateRepository.date);
    await createTaskInstance(task, dateRepository.dateAfter);
  }

  // creates a task instance for the task on the date
  // if the task is scheduled for the date
  // and there is not an existing task instance for the task on the date
  Future<void> createTaskInstance(Task task, DateTime date) async {
    if (date.isBefore(task.createdOn) ||
        !task.isScheduled(currentDate: date) ||
        await _taskInstanceExists(task: task, date: date)) {
      return;
    }

    await setTaskInstance(
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
}

final taskInstancesServiceProvider = Provider<TaskInstancesService>(
  (ref) {
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
  },
);

final taskInstancesStreamProvider = StreamProvider<List<TaskInstance>>(
  (ref) {
    final user = ref.watch(authStateChangesProvider).value;
    if (user == null) {
      return ref
          .watch(localTaskInstancesRepositoryProvider)
          .watchTaskInstances();
    }
    return ref
        .watch(remoteTaskInstancesRepositoryProvider)
        .watchTaskInstances(user.uid);
  },
);

final dateTaskInstancesStreamProvider =
    StreamProvider.autoDispose.family<List<TaskInstance>, DateTime>(
  (ref, date) {
    final user = ref.watch(authStateChangesProvider).value;
    if (user == null) {
      return ref
          .watch(localTaskInstancesRepositoryProvider)
          .watchTaskInstances(date: date);
    }
    return ref
        .watch(remoteTaskInstancesRepositoryProvider)
        .watchTaskInstances(user.uid, date: date);
  },
);
