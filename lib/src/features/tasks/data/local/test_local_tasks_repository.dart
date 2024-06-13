import 'package:collection/collection.dart';
import 'package:flow/src/constants/test_tasks.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestLocalTasksRepository implements LocalTasksRepository {
  TestLocalTasksRepository({this.addDelay = true});

  final bool addDelay;
  Tasks _tasks = kTestTasks;

  @override
  Future<Tasks> fetchTasks() async {
    await delay(addDelay);
    return Future.value(_tasks);
  }

  @override
  Future<void> setTasks(Tasks tasks) async {
    _tasks = tasks;
  }

  @override
  Stream<Tasks> watchTasks() async* {
    await delay(addDelay);
    yield _tasks;
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
