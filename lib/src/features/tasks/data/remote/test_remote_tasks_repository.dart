import 'package:collection/collection.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flow/src/utils/in_memory_store.dart';

class TestRemoteTasksRepository implements RemoteTasksRepository {
  TestRemoteTasksRepository({this.addDelay = true});

  final bool addDelay;

  /// An InMemoryStore containing the tasks data for all users, where:
  /// key: uid of the user
  /// value: tasks list of that user
  final _tasks = InMemoryStore<Map<String, List<Task>>>({});

  @override
  Future<void> setTasks(String uid, List<Task> userTasks) async {
    await delay(addDelay);
    // First, get the current tasks data for all users
    final tasks = _tasks.value;
    // Then, set the tasks for the given uid
    tasks[uid] = userTasks;
    // Finally, update the tasks data (will emit a new value)
    _tasks.value = tasks;
  }

  @override
  Future<List<Task>> fetchTasks(String uid) async {
    await delay(addDelay);
    return Future.value(_tasks.value[uid] ?? []);
  }

  @override
  Future<Task?> fetchTask(String uid, String taskId) async {
    final userTasks = await fetchTasks(uid);
    return Future.value(
      userTasks.firstWhereOrNull((task) => task.id == taskId),
    );
  }

  @override
  Stream<List<Task>> watchTasks(String uid) {
    return _tasks.stream.map((tasksData) => tasksData[uid] ?? []);
  }

  @override
  Stream<Task?> watchTask(String uid, String taskId) {
    return watchTasks(uid).map(
      (tasks) => tasks.firstWhereOrNull((task) => task.id == taskId),
    );
  }
}
