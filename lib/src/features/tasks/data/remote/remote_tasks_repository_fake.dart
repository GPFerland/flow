import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flow/src/utils/in_memory_store.dart';

class FakeRemoteTasksRepository implements RemoteTasksRepository {
  FakeRemoteTasksRepository({
    this.addDelay = true,
  });

  final bool addDelay;

  // create [InMemoryStore] repository for all the users tasks, where:
  // key: uid of the user
  // value: tasks of that user
  final _tasks = InMemoryStore<Map<String, List<Task>>>({});

  // * create
  @override
  Future<void> createTask(String uid, Task task) async {
    await delay(addDelay);
    final repoTasks = _tasks.value;
    final userTasks = repoTasks[uid] ?? [];
    final index = _getTaskIndex(userTasks, task.id);
    if (index == -1) {
      // if not found, create a new task
      userTasks.add(task);
    } else {
      //todo - raise error or update the task?
    }
    repoTasks[uid] = userTasks;
    _tasks.value = repoTasks;
  }

  @override
  Future<void> createTasks(String uid, List<Task> tasks) async {
    await delay(addDelay);
    final repoTasks = _tasks.value;
    final userTasks = repoTasks[uid] ?? [];
    for (Task task in tasks) {
      final index = _getTaskIndex(userTasks, task.id);
      // if not found
      if (index == -1) {
        // add to the users tasks
        userTasks.add(task);
      } else {
        //todo - raise error or update the task?
      }
    }
    repoTasks[uid] = userTasks;
    _tasks.value = repoTasks;
  }

  // * read
  @override
  Future<Task?> fetchTask(String uid, String taskId) async {
    final userTasks = await fetchTasks(uid);
    return _getTask(userTasks, taskId);
  }

  @override
  Future<List<Task>> fetchTasks(String uid) async {
    return Future.value(_tasks.value[uid]);
  }

  @override
  Stream<Task?> watchTask(String uid, String taskId) {
    return watchTasks(uid).map(
      (userTasks) => _getTask(userTasks, taskId),
    );
  }

  @override
  Stream<List<Task>> watchTasks(String uid) {
    return _tasks.stream.map(
      (repoTasks) => repoTasks[uid] ?? [],
    );
  }

  // * update
  @override
  Future<void> updateTask(String uid, Task task) async {
    await delay(addDelay);
    final repoTasks = _tasks.value;
    final userTasks = repoTasks[uid] ?? [];
    final index = _getTaskIndex(userTasks, task.id);
    if (index == -1) {
      //todo - if not found, create a new task ??
    } else {
      userTasks[index] = task;
    }
    repoTasks[uid] = userTasks;
    _tasks.value = repoTasks;
  }

  @override
  Future<void> updateTasks(String uid, List<Task> tasks) async {
    await delay(addDelay);
    final repoTasks = _tasks.value;
    final userTasks = repoTasks[uid] ?? [];
    for (Task task in tasks) {
      final index = _getTaskIndex(userTasks, task.id);
      if (index == -1) {
        //todo - if not found, create a new task ??
      } else {
        userTasks[index] = task;
      }
    }
    repoTasks[uid] = userTasks;
    _tasks.value = repoTasks;
  }

  // * delete
  @override
  Future<void> deleteTask(String uid, String taskId) async {
    await delay(addDelay);
    final repoTasks = _tasks.value;
    final userTasks = repoTasks[uid] ?? [];
    final index = _getTaskIndex(userTasks, taskId);
    if (index == -1) {
      //todo - if not found, do nothing?
    } else {
      userTasks.removeAt(index);
    }
    repoTasks[uid] = userTasks;
    _tasks.value = repoTasks;
  }

  @override
  Future<void> deleteTasks(String uid, List<String> taskIds) async {
    await delay(addDelay);
    final repoTasks = _tasks.value;
    final userTasks = repoTasks[uid] ?? [];
    for (String taskId in taskIds) {
      final index = _getTaskIndex(userTasks, taskId);
      if (index == -1) {
        //todo - if not found, do nothing?
      } else {
        userTasks.removeAt(index);
      }
    }
    repoTasks[uid] = userTasks;
    _tasks.value = repoTasks;
  }

  // * todo - search???
  @override
  Query<Task> tasksQuery(String uid) {
    // todo: implement tasksQuery
    throw UnimplementedError();
  }

  // * helper methods
  static Task? _getTask(List<Task> tasks, String taskId) {
    return tasks.firstWhereOrNull((task) => task.id == taskId);
  }

  static int _getTaskIndex(List<Task> tasks, String taskId) {
    return tasks.indexWhere((task) => task.id == taskId);
  }
}
