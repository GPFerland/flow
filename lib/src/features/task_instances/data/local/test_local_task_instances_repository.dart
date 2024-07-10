import 'package:collection/collection.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:rxdart/rxdart.dart';

class TestLocalTaskInstancesRepository implements LocalTaskInstancesRepository {
  TestLocalTaskInstancesRepository({this.addDelay = true});

  final bool addDelay;

  List<TaskInstance> _taskInstances = [];

  final _taskInstancesStreamController =
      BehaviorSubject<List<TaskInstance>>.seeded([]);

  @override
  Future<void> setTaskInstances(List<TaskInstance> taskInstances) async {
    await delay(addDelay);
    _taskInstances = taskInstances;
    _taskInstancesStreamController.add(taskInstances);
  }

  @override
  Future<List<TaskInstance>> fetchTaskInstances() async {
    await delay(addDelay);
    return Future.value(_taskInstances);
  }

  @override
  Future<TaskInstance?> fetchTaskInstance(String taskInstanceId) async {
    final taskInstances = await fetchTaskInstances();
    return taskInstances.firstWhereOrNull(
      (taskInstance) => taskInstance.id == taskInstanceId,
    );
  }

  @override
  Stream<List<TaskInstance>> watchTaskInstances() {
    return _taskInstancesStreamController.stream;
  }

  @override
  Stream<TaskInstance?> watchTaskInstance(String taskInstanceId) {
    return watchTaskInstances().map(
      (taskInstances) => taskInstances.firstWhereOrNull(
        (taskInstance) => taskInstance.id == taskInstanceId,
      ),
    );
  }
}
