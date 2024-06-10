import 'package:flow/src/constants/test_tasks.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

class TestTasksRepository {
  TestTasksRepository({this.addDelay = true});

  final bool addDelay;
  final List<Task> _tasks = kTestTasks;

  List<Task> getTasksList() {
    return _tasks;
  }

  Task? getTask(String id) {
    return _tasks.firstWhereOrNull((task) => task.id == id);
  }

  Future<List<Task>> fetchTasksList() async {
    await delay(addDelay);
    return Future.value(_tasks);
  }

  Stream<List<Task>> watchTasksList() async* {
    await delay(addDelay);
    yield _tasks;
  }

  Stream<Task?> watchTask(String id) {
    return watchTasksList().map(
      (tasks) => tasks.firstWhereOrNull((task) => task.id == id),
    );
  }
}

final tasksRepositoryProvider = Provider<TestTasksRepository>((ref) {
  return TestTasksRepository();
});

final tasksListStreamProvider = StreamProvider.autoDispose<List<Task>>((ref) {
  final tasksRepository = ref.watch(tasksRepositoryProvider);
  return tasksRepository.watchTasksList();
});

final tasksListFutureProvider = FutureProvider.autoDispose<List<Task>>((ref) {
  final tasksRepository = ref.watch(tasksRepositoryProvider);
  return tasksRepository.fetchTasksList();
});

final taskStreamProvider =
    StreamProvider.autoDispose.family<Task?, String>((ref, id) {
  final tasksRepository = ref.watch(tasksRepositoryProvider);
  return tasksRepository.watchTask(id);
});
