import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instances.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class TaskInstancesService {
  TaskInstancesService({
    required this.authRepository,
    required this.localTaskInstancesRepository,
    required this.remoteTaskInstancesRepository,
  });

  final TestAuthRepository authRepository;
  final LocalTaskInstancesRepository localTaskInstancesRepository;
  final RemoteTaskInstancesRepository remoteTaskInstancesRepository;

  /// fetch the task instances from the local or remote repository
  /// depending on the user auth state
  Future<TaskInstances> _fetchTaskInstances() {
    final user = authRepository.currentUser;
    if (user != null) {
      return remoteTaskInstancesRepository.fetchTaskInstances(user.uid);
    } else {
      return localTaskInstancesRepository.fetchTaskInstances();
    }
  }

  /// save the task instances to the local or remote repository
  /// depending on the user auth state
  Future<void> _setTaskInstances(TaskInstances taskInstances) async {
    final user = authRepository.currentUser;
    if (user != null) {
      await remoteTaskInstancesRepository.setTaskInstances(
        user.uid,
        taskInstances,
      );
    } else {
      await localTaskInstancesRepository.setTaskInstances(
        taskInstances,
      );
    }
  }

  /// adds a task instance in the local or remote repository
  /// depending on the user auth state
  Future<void> addTaskInstance(TaskInstance taskInstance) async {
    final taskInstances = await _fetchTaskInstances();
    final updated = taskInstances.addTaskInstance(taskInstance);
    await _setTaskInstances(updated);
  }

  /// sets a task instance in the local or remote repository
  /// depending on the user auth state
  Future<void> setTaskInstance(TaskInstance taskInstance) async {
    final taskInstances = await _fetchTaskInstances();
    final updated = taskInstances.setTaskInstance(taskInstance);
    await _setTaskInstances(updated);
  }

  /// sets task instances to the local or remote repository
  /// depending on the user auth state
  Future<void> setTaskInstances(TaskInstances taskInstances) async {
    await _setTaskInstances(taskInstances);
  }

  /// removes a task instance from the local or remote repository
  /// depending on the user auth state
  Future<void> removeTaskInstance(TaskInstance taskInstance) async {
    final taskInstances = await _fetchTaskInstances();
    final updated = taskInstances.removeTaskInstance(taskInstance);
    await _setTaskInstances(updated);
  }

  /// removes all task instances associated with the provided task id
  Future<void> removeTasksInstances(String taskId) async {
    final taskInstances = await _fetchTaskInstances();
    final updated = taskInstances.removeTasksInstances(taskId);
    await _setTaskInstances(updated);
  }

  // creates a task instance for the task on the date
  // if the task is scheduled for the date
  // and there is not an existing task instance for the task on the date
  Future<void> createTaskInstance(Task task, DateTime date) async {
    if (!_taskScheduledOnDate(task: task, date: date) ||
        await _taskInstanceExistsForDate(task: task, date: date)) {
      return;
    }

    await addTaskInstance(TaskInstance(
      id: const Uuid().v4(),
      taskId: task.id,
      initialDate: date,
    ));
  }

  bool _taskScheduledOnDate({
    required Task task,
    required DateTime date,
  }) {
    switch (task.frequencyType) {
      case FrequencyType.once:
        if (date == task.date) {
          return true;
        }
      case FrequencyType.daily:
        return true;
      case FrequencyType.weekly:
        for (Weekday weekday in task.weekdays) {
          if (weekday.weekdayIndex == date.weekday) {
            return true;
          }
        }
      case FrequencyType.monthly:
        for (Monthday monthday in task.monthdays) {
          if (_monthdayMatch(monthday, date)) {
            return true;
          }
        }
    }
    return false;
  }

  Future<bool> _taskInstanceExistsForDate({
    required Task task,
    required DateTime date,
  }) async {
    final taskInstances = await _fetchTaskInstances();

    final filteredTaskInstances = taskInstances.taskInstancesList
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

  bool _monthdayMatch(Monthday monthday, DateTime date) {
    DateTime? tempDate;
    int occurrenceNum = monthday.ordinal.index;
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    final lastDayOfLastMonth = DateTime(date.year, date.month, 0);

    if (monthday.weekday == Weekday.day) {
      if (monthday.ordinal == Ordinal.last) {
        tempDate = _chooseLastDayOfMonth(
          date,
          lastDayOfMonth,
          lastDayOfLastMonth,
        );
      } else {
        tempDate = firstDayOfMonth.add(Duration(days: occurrenceNum));
      }
    } else {
      if (monthday.ordinal == Ordinal.last) {
        tempDate = _chooseLastDayOfMonth(
          date,
          _subtractTillWeekday(
            lastDayOfMonth,
            monthday.weekday.weekdayIndex,
          ),
          _subtractTillWeekday(
            lastDayOfLastMonth,
            monthday.weekday.weekdayIndex,
          ),
        );
      } else {
        final firstWeekdayOfMonth = _addTillWeekday(
          firstDayOfMonth,
          monthday.weekday.weekdayIndex,
        );

        int occurrenceCount = 0;
        for (DateTime loopDate = firstWeekdayOfMonth;
            loopDate.month == date.month;
            loopDate = loopDate.add(const Duration(days: 7))) {
          if (occurrenceCount == occurrenceNum) {
            tempDate = loopDate;
          }
          occurrenceCount++;
        }
      }
    }

    if (tempDate == date) {
      return true;
    } else {
      return false;
    }
  }

  DateTime _addTillWeekday(DateTime date, int dayOfWeekIndex) {
    while (date.weekday != dayOfWeekIndex) {
      date = date.add(
        const Duration(days: 1),
      );
    }
    return date;
  }

  DateTime _subtractTillWeekday(DateTime date, int dayOfWeekIndex) {
    while (date.weekday != dayOfWeekIndex) {
      date = date.subtract(
        const Duration(days: 1),
      );
    }
    return date;
  }

  DateTime _chooseLastDayOfMonth(
    DateTime date,
    DateTime lastDayOfMonth,
    DateTime lastDayOfLastMonth,
  ) {
    if (date.isBefore(lastDayOfMonth)) {
      return lastDayOfLastMonth;
    } else {
      return lastDayOfMonth;
    }
  }
}

final taskInstancesServiceProvider = Provider<TaskInstancesService>(
  (ref) {
    return TaskInstancesService(
      authRepository: ref.watch(
        authRepositoryProvider,
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

final dateTaskInstancesProvider =
    StreamProvider.autoDispose.family<TaskInstances, DateTime>(
  (ref, date) {
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      return ref
          .watch(remoteTaskInstancesRepositoryProvider)
          .watchDateTaskInstances(user.uid, date);
    } else {
      return ref
          .watch(localTaskInstancesRepositoryProvider)
          .watchDateTaskInstances(date);
    }
  },
);
