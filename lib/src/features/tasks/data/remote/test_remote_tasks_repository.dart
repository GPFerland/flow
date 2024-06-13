import 'package:collection/collection.dart';
import 'package:flow/src/constants/test_tasks.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flow/src/utils/remote_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestRemoteTasksRepository implements RemoteTasksRepository {
  TestRemoteTasksRepository({this.addDelay = true});

  final bool addDelay;
  Tasks _tasks = kTestTasks;

  @override
  Future<Tasks> fetchTasks(String uid) async {
    await delay(addDelay);
    return Future.value(_tasks);
  }

  @override
  Future<void> setTasks(String userId, Tasks tasks) async {
    _tasks = tasks;
  }

  @override
  Stream<Tasks> watchTasks(String uid) async* {
    await delay(addDelay);
    yield _tasks;
  }

  @override
  Stream<Task?> watchTask(String uid, String id) {
    return watchTasks(uid).map(
      (tasks) => tasks.tasksList.firstWhereOrNull((task) => task.id == id),
    );
  }
}

final testRemoteTasksRepositoryProvider = Provider<TestRemoteTasksRepository>(
  (ref) {
    return TestRemoteTasksRepository();
  },
);

final testRemoteTasksListStreamProvider =
    StreamProvider.autoDispose.family<Tasks, String>(
  (ref, uid) {
    final tasksRepository = ref.watch(testRemoteTasksRepositoryProvider);
    return tasksRepository.watchTasks(uid);
  },
);

final testRemoteTasksListFutureProvider =
    FutureProvider.autoDispose.family<Tasks, String>(
  (ref, uid) {
    final tasksRepository = ref.watch(testRemoteTasksRepositoryProvider);
    return tasksRepository.fetchTasks(uid);
  },
);

final testRemoteTaskStreamProvider =
    StreamProvider.autoDispose.family<Task?, RemoteItem>(
  (ref, remoteItem) {
    final tasksRepository = ref.watch(testRemoteTasksRepositoryProvider);
    return tasksRepository.watchTask(remoteItem.userId, remoteItem.itemId);
  },
);
