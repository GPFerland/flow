import 'package:flow/src/constants/test_tasks.dart';
import 'package:flow/src/features/tasks/data/local/test_local_tasks_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestLocalTasksRepository makeTasksRepository() => TestLocalTasksRepository(
        addDelay: false,
      );

  group('TestTasksRepository', () {
    test('fetchTasksList returns global list', () async {
      final tasksRepository = makeTasksRepository();
      expect(
        await tasksRepository.fetchTasks(),
        kTestTasks,
      );
    });

    test('watchTasksList emits global list', () {
      final tasksRepository = makeTasksRepository();
      expect(
        tasksRepository.watchTasks(),
        emits(kTestTasks),
      );
    });

    test('watchTask(1) emits first item', () {
      final tasksRepository = makeTasksRepository();
      expect(
        tasksRepository.watchTask('1'),
        emits(kTestTasks.tasksList[0]),
      );
    });

    test('watchTask(100) emits null', () {
      final tasksRepository = makeTasksRepository();
      expect(
        tasksRepository.watchTask('100'),
        emits(null),
      );
    });
  });
}
