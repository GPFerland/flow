import 'package:flow/src/features/tasks/data/local/local_tasks_repository_fake.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeLocalTasksRepository makeTasksRepository() => FakeLocalTasksRepository();

  group('TestTasksRepository', () {
    test('fetchTasksList returns global list', () async {
      final tasksRepository = makeTasksRepository();
      expect(
        await tasksRepository.fetchTasks(),
        [],
      );
    });

    test('watchTasksList emits global list', () {
      final tasksRepository = makeTasksRepository();
      expect(
        tasksRepository.watchTasks(),
        emits([]),
      );
    });

    test('watchTask(1) emits first item', () {
      final tasksRepository = makeTasksRepository();
      expect(
        tasksRepository.watchTask('1'),
        emits(null),
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
