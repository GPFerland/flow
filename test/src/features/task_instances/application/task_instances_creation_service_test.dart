import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_creation_service.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(createTestTask());
  });

  late DateRepository dateRepository;
  late MockTasksService tasksService;
  late MockTaskInstancesService taskInstancesService;

  setUp(
    () {
      dateRepository = MockDateRepository();
      tasksService = MockTasksService();
      taskInstancesService = MockTaskInstancesService();
    },
  );

  TaskInstancesCreationService makeTaskInstancesCreationService(
    List<Task> tasks,
  ) {
    final container = ProviderContainer(overrides: [
      dateRepositoryProvider.overrideWithValue(dateRepository),
      tasksServiceProvider.overrideWithValue(tasksService),
      taskInstancesServiceProvider.overrideWithValue(taskInstancesService),
    ]);
    addTearDown(container.dispose);
    return container.read(taskInstancesCreationServiceProvider);
  }

  group('TaskInstancesCreationService', () {
    Future<void> runTaskInstancesCreationTest({
      required List<Task> tasks,
    }) async {
      // setup
      final testDates = [
        getDateNoTimeYesterday(),
        getDateNoTimeToday(),
        getDateNoTimeTomorrow(),
      ];
      when(dateRepository.dateStateChanges).thenAnswer(
        (_) => Stream.value(getDateNoTimeToday()),
      );
      for (final task in tasks) {
        for (final date in testDates) {
          when(
            () => taskInstancesService.createTasksInstances(task, [date]),
          ).thenAnswer(
            (_) => Future.value(),
          );
        }
      }
      // run - create task instances creation service to trigger creation
      makeTaskInstancesCreationService(tasks);
      // // wait for all the stubbed methods to return a value
      await Future.delayed(const Duration());
      //verify
      if (tasks.isEmpty) {
        verifyNever(
          () => taskInstancesService.createTasksInstances(any(), any()),
        );
      } else {
        for (final task in tasks) {
          for (final date in testDates) {
            verify(
              () => taskInstancesService.createTasksInstances(task, [date]),
            ).called(1);
          }
        }
      }
    }

    test('no task, no attempts to create task instances', () async {
      await runTaskInstancesCreationTest(
        tasks: [],
      );
    });

    test('one task, attempts to create task instances', () async {
      await runTaskInstancesCreationTest(
        tasks: [createTestTask()],
      );
    });

    test('multiple tasks, attempts to create task instances', () async {
      await runTaskInstancesCreationTest(
        tasks: [
          createTestTask(id: '1'),
          createTestTask(id: '2'),
        ],
      );
    });
  });
}
