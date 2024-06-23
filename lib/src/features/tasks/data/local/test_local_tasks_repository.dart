import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class TestLocalTasksRepository implements LocalTasksRepository {
  TestLocalTasksRepository();
  Tasks _tasks = Tasks(tasksList: []);

  final _tasksStreamController = BehaviorSubject<Tasks>.seeded(
    Tasks(tasksList: []),
  );

  @override
  Future<Tasks> fetchTasks() async {
    return Future.value(_tasks);
  }

  @override
  Future<Task?> fetchTask(String id) async {
    return Future.value(
      _tasks.tasksList.firstWhereOrNull((task) => task.id == id),
    );
  }

  @override
  Future<void> setTasks(Tasks tasks) async {
    _tasks = tasks;
    _tasksStreamController.add(tasks);
  }

  @override
  Stream<Tasks> watchTasks() {
    return _tasksStreamController.stream;
  }

  @override
  Stream<Task?> watchTask(String id) {
    return watchTasks().map(
      (tasks) => tasks.tasksList.firstWhereOrNull((task) => task.id == id),
    );
  }
}

final testLocalTasksRepositoryProvider =
    Provider<TestLocalTasksRepository>((ref) {
  return TestLocalTasksRepository();
});
