import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flow/src/utils/in_memory_store.dart';

class FakeLocalTasksRepository implements LocalTasksRepository {
  FakeLocalTasksRepository({
    this.addDelay = true,
  });

  final bool addDelay;

  // create [InMemoryStore] repository for the local users tasks
  final _tasks = InMemoryStore<List<Task>>([]);

  // * create
  @override
  Future<void> createTask(Task task) async {
    await delay(addDelay);
    final repoTasks = _tasks.value;
    final index = _getTaskIndex(repoTasks, task.id);
    if (index == -1) {
      // if not found, create a new task
      repoTasks.add(task);
    } else {
      //todo - raise error or update the task?
    }
    _tasks.value = repoTasks;
  }

  @override
  Future<void> createTasks(List<Task> tasks) async {
    await delay(addDelay);
    final repoTasks = _tasks.value;
    for (Task task in tasks) {
      final index = _getTaskIndex(repoTasks, task.id);
      if (index == -1) {
        // if not found, create a new task
        repoTasks.add(task);
      } else {
        //todo - raise error or update the task?
      }
    }
    _tasks.value = repoTasks;
  }

  // * read
  @override
  Future<Task?> fetchTask(String taskId) async {
    final repoTasks = await fetchTasks();
    return _getTask(repoTasks, taskId);
  }

  @override
  Future<List<Task>> fetchTasks() async {
    return Future.value(_tasks.value);
  }

  @override
  Stream<Task?> watchTask(String taskId) {
    return watchTasks().map(
      (repoTasks) => _getTask(repoTasks, taskId),
    );
  }

  @override
  Stream<List<Task>> watchTasks() {
    return _tasks.stream;
  }

  // * update
  @override
  Future<void> updateTask(Task task) async {
    await delay(addDelay);
    final repoTasks = _tasks.value;
    final index = _getTaskIndex(repoTasks, task.id);
    if (index == -1) {
      //todo - if not found, create a new task ??
    } else {
      repoTasks[index] = task;
    }
    _tasks.value = repoTasks;
  }

  @override
  Future<void> updateTasks(List<Task> tasks) async {
    await delay(addDelay);
    final repoTasks = _tasks.value;
    for (Task task in tasks) {
      final index = _getTaskIndex(repoTasks, task.id);
      if (index == -1) {
        //todo - if not found, create a new task
      } else {
        repoTasks[index] = task;
      }
    }
    _tasks.value = repoTasks;
  }

  // * delete
  @override
  Future<void> deleteTask(String taskId) async {
    await delay(addDelay);
    final repoTasks = _tasks.value;
    final index = _getTaskIndex(repoTasks, taskId);
    if (index == -1) {
      //todo - if not found, do nothing?
    } else {
      repoTasks.removeAt(index);
    }
    _tasks.value = repoTasks;
  }

  @override
  Future<void> deleteTasks(List<String> taskIds) async {
    await delay(addDelay);
    final repoTasks = _tasks.value;
    for (String taskId in taskIds) {
      final index = _getTaskIndex(repoTasks, taskId);
      if (index == -1) {
        //todo - if not found, do nothing?
      } else {
        repoTasks.removeAt(index);
      }
    }
    _tasks.value = repoTasks;
  }

  // * helper methods
  static Task? _getTask(List<Task> tasks, String taskId) {
    return tasks.firstWhereOrNull((task) => task.id == taskId);
  }

  static int _getTaskIndex(List<Task> tasks, String taskId) {
    return tasks.indexWhere((task) => task.id == taskId);
  }
}
