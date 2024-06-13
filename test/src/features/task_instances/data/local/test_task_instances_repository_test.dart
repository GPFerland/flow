import 'package:flow/src/constants/test_task_instances.dart';
import 'package:flow/src/features/task_instances/data/local/test_local_task_instances_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestLocalTaskInstancesRepository makeTaskInstancesRepository() =>
      TestLocalTaskInstancesRepository(
        addDelay: false,
      );

  group('TestTaskInstancesRepository', () {
    test('fetchTaskInstancesList returns global list', () async {
      final tasksRepository = makeTaskInstancesRepository();
      expect(
        await tasksRepository.fetchTaskInstances(),
        kTestTaskInstances,
      );
    });

    test('watchTaskInstancesList emits global list', () {
      final tasksRepository = makeTaskInstancesRepository();
      expect(
        tasksRepository.watchTaskInstances(),
        emits(kTestTaskInstances),
      );
    });

    test('watchTaskInstance(1) emits first item', () {
      final tasksRepository = makeTaskInstancesRepository();
      expect(
        tasksRepository.watchTaskInstance('1'),
        emits(kTestTaskInstances.taskInstancesList[0]),
      );
    });

    test('watchTaskInstance(100) emits null', () {
      final tasksRepository = makeTaskInstancesRepository();
      expect(
        tasksRepository.watchTaskInstance('100'),
        emits(null),
      );
    });
  });
}
