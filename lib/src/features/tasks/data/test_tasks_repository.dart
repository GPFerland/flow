import 'package:flow/src/constants/test_tasks.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeTasksRepository {
  final List<Task> _tasks = kTestTasks;

  List<Task> getTasksList() {
    return _tasks;
  }

  Task? getTask(String id) {
    return _tasks.firstWhere((task) => task.id == id);
  }

  Future<List<Task>> fetchTasksList() async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(_tasks);
  }

  Stream<List<Task>> watchTasksList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _tasks;
  }

  Stream<Task?> watchTask(String id) {
    return watchTasksList()
        .map((tasks) => tasks.firstWhere((task) => task.id == id));
  }
}

final tasksRepositoryProvider = Provider<FakeTasksRepository>((ref) {
  return FakeTasksRepository();
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
