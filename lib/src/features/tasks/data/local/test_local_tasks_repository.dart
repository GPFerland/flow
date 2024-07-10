import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:rxdart/rxdart.dart';

class TestLocalTasksRepository implements LocalTasksRepository {
  TestLocalTasksRepository({this.addDelay = true});

  final bool addDelay;

  List<Task> _tasks = [];

  final _tasksStreamController = BehaviorSubject<List<Task>>.seeded([]);

  @override
  Future<void> setTasks(List<Task> tasks) async {
    await delay(addDelay);
    _tasks = tasks;
    _tasksStreamController.add(tasks);
  }

  @override
  Future<List<Task>> fetchTasks() async {
    await delay(addDelay);
    return Future.value(_tasks);
  }

  @override
  Future<Task?> fetchTask(String taskId) async {
    final tasks = await fetchTasks();
    return tasks.firstWhereOrNull((task) => task.id == taskId);
  }

  @override
  Stream<List<Task>> watchTasks() {
    return _tasksStreamController.stream;
  }

  @override
  Stream<Task?> watchTask(String taskId) {
    return watchTasks().map(
      (tasks) => tasks.firstWhereOrNull((task) => task.id == taskId),
    );
  }
}
