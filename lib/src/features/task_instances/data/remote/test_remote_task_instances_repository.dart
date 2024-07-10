import 'package:collection/collection.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flow/src/utils/in_memory_store.dart';

class TestRemoteTaskInstancesRepository
    implements RemoteTaskInstancesRepository {
  TestRemoteTaskInstancesRepository({this.addDelay = true});

  final bool addDelay;

  /// An InMemoryStore containing the task instances data for all users, where:
  /// key: uid of the user
  /// value: task instances list of that user
  final _taskInstances = InMemoryStore<Map<String, List<TaskInstance>>>({});

  @override
  Future<void> setTaskInstances(
    String uid,
    List<TaskInstance> userTaskInstances,
  ) async {
    await delay(addDelay);
    // First, get the current task instances data for all users
    final taskInstances = _taskInstances.value;
    // Then, set the task instances for the given uid
    taskInstances[uid] = userTaskInstances;
    // Finally, update the task instances data (will emit a new value)
    _taskInstances.value = taskInstances;
  }

  @override
  Future<List<TaskInstance>> fetchTaskInstances(String uid) async {
    await delay(addDelay);
    return Future.value(_taskInstances.value[uid] ?? []);
  }

  @override
  Future<TaskInstance?> fetchTaskInstance(
    String uid,
    String taskInstanceId,
  ) async {
    final userTaskInstances = await fetchTaskInstances(uid);
    return Future.value(
      userTaskInstances.firstWhereOrNull(
        (taskInstance) => taskInstance.id == taskInstanceId,
      ),
    );
  }

  @override
  Stream<List<TaskInstance>> watchTaskInstances(String uid) {
    return _taskInstances.stream.map(
      (taskInstancesData) => taskInstancesData[uid] ?? [],
    );
  }

  @override
  Stream<TaskInstance?> watchTaskInstance(
    String uid,
    String taskInstanceId,
  ) {
    return watchTaskInstances(uid).map(
      (taskInstances) => taskInstances.firstWhereOrNull(
        (taskInstance) => taskInstance.id == taskInstanceId,
      ),
    );
  }
}
