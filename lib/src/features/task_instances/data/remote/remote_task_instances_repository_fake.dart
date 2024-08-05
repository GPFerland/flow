import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flow/src/utils/in_memory_store.dart';

class FakeRemoteTaskInstancesRepository
    implements RemoteTaskInstancesRepository {
  FakeRemoteTaskInstancesRepository({
    this.addDelay = true,
  });

  final bool addDelay;

  // create [InMemoryStore] repository for all the users task instances, where:
  // key: uid of the user
  // value: task instances of that user
  final _taskInstances = InMemoryStore<Map<String, List<TaskInstance>>>({});

  // * create
  @override
  Future<void> createTaskInstance(
    String uid,
    TaskInstance taskInstance,
  ) async {
    await delay(addDelay);
    final repoTaskInstances = _taskInstances.value;
    final userTaskInstances = repoTaskInstances[uid] ?? [];
    final index = _getTaskInstanceIndex(userTaskInstances, taskInstance.id);
    // if not found
    if (index == -1) {
      // create a new task instance
      userTaskInstances.add(taskInstance);
    } else {
      //todo - raise error or update the task instance?
    }
    repoTaskInstances[uid] = userTaskInstances;
    _taskInstances.value = repoTaskInstances;
  }

  @override
  Future<void> createTaskInstances(
    String uid,
    List<TaskInstance> taskInstances,
  ) async {
    await delay(addDelay);
    final repoTaskInstances = _taskInstances.value;
    final userTaskInstances = repoTaskInstances[uid] ?? [];
    for (TaskInstance taskInstance in taskInstances) {
      final index = _getTaskInstanceIndex(userTaskInstances, taskInstance.id);
      // if not found
      if (index == -1) {
        // create a new task instance
        userTaskInstances.add(taskInstance);
      } else {
        //todo - raise error or update the task instance?
      }
    }
    repoTaskInstances[uid] = userTaskInstances;
    _taskInstances.value = repoTaskInstances;
  }

  // * read
  @override
  Future<TaskInstance?> fetchTaskInstance(
      String uid, String taskInstanceId) async {
    final userTaskInstances = await fetchTaskInstances(uid);
    return _getTaskInstance(userTaskInstances, taskInstanceId);
  }

  @override
  Future<List<TaskInstance>> fetchTaskInstances(String uid) async {
    return Future.value(_taskInstances.value[uid] ?? []);
  }

  @override
  Stream<TaskInstance?> watchTaskInstance(String uid, String taskInstanceId) {
    return watchTaskInstances(uid, null).map(
      (userTaskInstances) => _getTaskInstance(
        userTaskInstances,
        taskInstanceId,
      ),
    );
  }

  @override
  Stream<List<TaskInstance>> watchTaskInstances(String uid, DateTime? date) {
    if (date == null) {
      return _taskInstances.stream.map(
        (repoTaskInstances) => repoTaskInstances[uid] ?? [],
      );
    } else {
      return _taskInstances.stream
          .map(
            (repoTaskInstances) => repoTaskInstances[uid] ?? [],
          )
          .map(
            (userInstances) => userInstances
                .where((taskInstance) => taskInstance.isDisplayed(date))
                .toList(),
          );
    }
  }

  // * update
  @override
  Future<void> updateTaskInstance(String uid, TaskInstance taskInstance) async {
    await delay(addDelay);
    final repoTaskInstances = _taskInstances.value;
    final userTaskInstances = repoTaskInstances[uid] ?? [];
    final index = _getTaskInstanceIndex(userTaskInstances, taskInstance.id);
    if (index == -1) {
      //todo - if not found, create a new task instance ??
    } else {
      userTaskInstances[index] = taskInstance;
    }
    repoTaskInstances[uid] = userTaskInstances;
    _taskInstances.value = repoTaskInstances;
  }

  @override
  Future<void> updateTaskInstances(
      String uid, List<TaskInstance> taskInstances) async {
    await delay(addDelay);
    final repoTaskInstances = _taskInstances.value;
    final userTaskInstances = repoTaskInstances[uid] ?? [];
    for (TaskInstance taskInstance in taskInstances) {
      final index = _getTaskInstanceIndex(userTaskInstances, taskInstance.id);
      if (index == -1) {
        //todo - if not found, create a new task instance ??
      } else {
        userTaskInstances[index] = taskInstance;
      }
    }
    repoTaskInstances[uid] = userTaskInstances;
    _taskInstances.value = repoTaskInstances;
  }

  // * delete
  @override
  Future<void> deleteTaskInstance(String uid, String taskInstanceId) async {
    await delay(addDelay);
    final repoTaskInstances = _taskInstances.value;
    final userTaskInstances = repoTaskInstances[uid] ?? [];
    final index = _getTaskInstanceIndex(userTaskInstances, taskInstanceId);
    if (index == -1) {
      //todo - if not found, do nothing?
    } else {
      userTaskInstances.removeAt(index);
    }
    repoTaskInstances[uid] = userTaskInstances;
    _taskInstances.value = repoTaskInstances;
  }

  @override
  Future<void> deleteTaskInstances(
      String uid, List<String> taskInstanceIds) async {
    await delay(addDelay);
    final repoTaskInstances = _taskInstances.value;
    final userTaskInstances = repoTaskInstances[uid] ?? [];
    for (String taskInstanceId in taskInstanceIds) {
      final index = _getTaskInstanceIndex(userTaskInstances, taskInstanceId);
      if (index == -1) {
        //todo - if not found, do nothing?
      } else {
        userTaskInstances.removeAt(index);
      }
    }
    repoTaskInstances[uid] = userTaskInstances;
    _taskInstances.value = repoTaskInstances;
  }

  // * todo - search???
  @override
  Query<TaskInstance> taskInstancesQuery(String uid) {
    // todo: implement taskInstancesQuery
    throw UnimplementedError();
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
