import 'package:flow/src/constants/test_tasks.dart';
import 'package:flow/src/features/tasks/data/test_tasks_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestTasksRepository makeTasksRepository() => TestTasksRepository(
        addDelay: false,
      );

  group('TestTasksRepository', () {
    test('getTasksList returns global list', () {
      final tasksRepository = makeTasksRepository();
      expect(
        tasksRepository.getTasksList(),
        kTestTasks,
      );
    });

    test('getTask(1) returns first item', () {
      final tasksRepository = makeTasksRepository();
      expect(
        tasksRepository.getTask('1'),
        kTestTasks[0],
      );
    });

    test('getTask(100) returns null', () {
      final tasksRepository = makeTasksRepository();
      expect(
        tasksRepository.getTask('100'),
        null,
      );
    });
  });

  test('fetchTasksList returns global list', () async {
    final tasksRepository = makeTasksRepository();
    expect(
      await tasksRepository.fetchTasksList(),
      kTestTasks,
    );
  });

  test('watchTasksList emits global list', () {
    final tasksRepository = makeTasksRepository();
    expect(
      tasksRepository.watchTasksList(),
      emits(kTestTasks),
    );
  });

  test('watchTask(1) emits first item', () {
    final tasksRepository = makeTasksRepository();
    expect(
      tasksRepository.watchTask('1'),
      emits(kTestTasks[0]),
    );
  });

  test('watchTask(100) emits null', () {
    final tasksRepository = makeTasksRepository();
    expect(
      tasksRepository.watchTask('100'),
      emits(null),
    );
  });
}
