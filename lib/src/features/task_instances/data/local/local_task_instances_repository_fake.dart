import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flow/src/utils/in_memory_store.dart';

class FakeLocalTaskInstancesRepository implements LocalTaskInstancesRepository {
  FakeLocalTaskInstancesRepository({
    this.addDelay = true,
  });

  final bool addDelay;

  // create [InMemoryStore] repository for the local users task instances
  final _taskInstances = InMemoryStore<List<TaskInstance>>([]);

  // * create
  @override
  Future<void> createTaskInstance(TaskInstance taskInstance) async {
    await delay(addDelay);
    final repoTaskInstances = _taskInstances.value;
    final index = _getTaskInstanceIndex(repoTaskInstances, taskInstance.id);
    if (index == -1) {
      // if not found, create a new task instance
      repoTaskInstances.add(taskInstance);
    } else {
      //todo - raise error or update the task instance?
    }
    _taskInstances.value = repoTaskInstances;
  }

  @override
  Future<void> createTaskInstances(List<TaskInstance> taskInstances) async {
    await delay(addDelay);
    final repoTaskInstances = _taskInstances.value;
    for (TaskInstance taskInstance in taskInstances) {
      final index = _getTaskInstanceIndex(repoTaskInstances, taskInstance.id);
      if (index == -1) {
        // if not found, create a new task instance
        repoTaskInstances.add(taskInstance);
      } else {
        //todo - raise error or update the task instance?
      }
    }
    _taskInstances.value = repoTaskInstances;
  }

  // * read
  @override
  Future<TaskInstance?> fetchTaskInstance(String taskInstanceId) async {
    final repoTaskInstances = await fetchTaskInstances();
    return _getTaskInstance(repoTaskInstances, taskInstanceId);
  }

  @override
  Future<List<TaskInstance>> fetchTaskInstances() async {
    return Future.value(_taskInstances.value);
  }

  @override
  Stream<TaskInstance?> watchTaskInstance(String taskInstanceId) {
    return watchTaskInstances(null).map(
      (repoTaskInstances) => _getTaskInstance(
        repoTaskInstances,
        taskInstanceId,
      ),
    );
  }

  @override
  Stream<List<TaskInstance>> watchTaskInstances(DateTime? date) {
    if (date == null) {
      return _taskInstances.stream;
    } else {
      return _taskInstances.stream.map((taskInstances) {
        return taskInstances
            .where((taskInstance) => taskInstance.isDisplayed(date))
            .toList();
      });
    }
  }

  // * update
  @override
  Future<void> updateTaskInstance(TaskInstance taskInstance) async {
    await delay(addDelay);
    final repoTaskInstances = _taskInstances.value;
    final index = _getTaskInstanceIndex(repoTaskInstances, taskInstance.id);
    if (index == -1) {
      //todo - if not found, create a new task instance ??
    } else {
      repoTaskInstances[index] = taskInstance;
    }
    _taskInstances.value = repoTaskInstances;
  }

  @override
  Future<void> updateTaskInstances(List<TaskInstance> taskInstances) async {
    await delay(addDelay);
    final repoTaskInstances = _taskInstances.value;
    for (TaskInstance taskInstance in taskInstances) {
      final index = _getTaskInstanceIndex(repoTaskInstances, taskInstance.id);
      if (index == -1) {
        //todo - if not found, create a new task instance
      } else {
        repoTaskInstances[index] = taskInstance;
      }
    }
    _taskInstances.value = repoTaskInstances;
  }

  // * delete
  @override
  Future<void> deleteTaskInstance(String taskInstanceId) async {
    await delay(addDelay);
    final repoTaskInstances = _taskInstances.value;
    final index = _getTaskInstanceIndex(repoTaskInstances, taskInstanceId);
    if (index == -1) {
      //todo - if not found, do nothing?
    } else {
      repoTaskInstances.removeAt(index);
    }
    _taskInstances.value = repoTaskInstances;
  }

  @override
  Future<void> deleteTaskInstances(List<String> taskInstanceIds) async {
    await delay(addDelay);
    final repoTaskInstances = _taskInstances.value;
    for (String taskInstanceId in taskInstanceIds) {
      final index = _getTaskInstanceIndex(repoTaskInstances, taskInstanceId);
      if (index == -1) {
        //todo - if not found, do nothing?
      } else {
        repoTaskInstances.removeAt(index);
      }
    }
    _taskInstances.value = repoTaskInstances;
  }

  // * helper methods
  static TaskInstance? _getTaskInstance(
    List<TaskInstance> taskInstances,
    String taskInstanceId,
  ) {
    return taskInstances.firstWhereOrNull(
      (taskInstance) => taskInstance.id == taskInstanceId,
    );
  }

  static int _getTaskInstanceIndex(
    List<TaskInstance> taskInstances,
    String taskInstanceId,
  ) {
    return taskInstances.indexWhere(
      (taskInstance) => taskInstance.id == taskInstanceId,
    );
  }
}
