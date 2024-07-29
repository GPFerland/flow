@Timeout(Duration(milliseconds: 500))
library;

import 'package:flow/src/features/tasks/presentation/tasks_list/task_list_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../../../utils.dart';

void main() {
  late MockTasksService tasksService;
  late MockTaskInstancesService taskInstancesService;
  late TaskListController taskListController;

  setUp(() {
    registerFallbackValue(createTestTask());
    tasksService = MockTasksService();
    taskInstancesService = MockTaskInstancesService();
    taskListController = TaskListController(
      tasksService: tasksService,
      taskInstancesService: taskInstancesService,
    );
  });

  group('TaskListController', () {
    test('initial state is AsyncValue.data', () {
      verifyNever(() => tasksService.setTasks(any()));
      expect(taskListController.state, const AsyncData<void>(null));
    });

    test('reorderTasks, success', () async {
      // setup
      final testTask1 = createTestTask(id: '1').copyWith(priority: 0);
      final testTask2 = createTestTask(id: '2').copyWith(priority: 1);
      final testTask3 = createTestTask(id: '3').copyWith(priority: 2);
      final testTasks = [
        testTask1,
        testTask2,
        testTask3,
      ];
      const oldIndex = 0;
      const newIndex = 3;
      final updatedTestTask1 = testTask1.copyWith(priority: 2);
      final updatedTestTask2 = testTask2.copyWith(priority: 0);
      final updatedTestTask3 = testTask3.copyWith(priority: 1);
      final reorderedTestTasks = [
        updatedTestTask2,
        updatedTestTask3,
        updatedTestTask1,
      ];
      when(() => tasksService.setTasks(reorderedTestTasks)).thenAnswer(
        (_) => Future.value(),
      );
      when(() => taskInstancesService
          .updateTaskInstancesPriority(reorderedTestTasks)).thenAnswer(
        (_) => Future.value(),
      );
      // expect later
      expectLater(
        taskListController.stream,
        emitsInOrder(const [
          AsyncLoading<void>(),
          AsyncData<void>(null),
        ]),
      );
      // run
      await taskListController.reorderTasks(
        testTasks,
        oldIndex,
        newIndex,
      );
      // verify
      verify(() => tasksService.setTasks(reorderedTestTasks)).called(1);
      verify(() => taskInstancesService.updateTaskInstancesPriority(
            reorderedTestTasks,
          )).called(1);
    });

    test('reorderTasks, failure', () async {
      // setup
      final testTask1 = createTestTask(id: '1').copyWith(priority: 0);
      final testTask2 = createTestTask(id: '2').copyWith(priority: 1);
      final testTask3 = createTestTask(id: '3').copyWith(priority: 2);
      final testTasks = [
        testTask1,
        testTask2,
        testTask3,
      ];
      const oldIndex = 0;
      const newIndex = 3;
      final updatedTestTask1 = testTask1.copyWith(priority: 2);
      final updatedTestTask2 = testTask2.copyWith(priority: 0);
      final updatedTestTask3 = testTask3.copyWith(priority: 1);
      final reorderedTestTasks = [
        updatedTestTask2,
        updatedTestTask3,
        updatedTestTask1,
      ];
      final exception = Exception('Connection failed');
      when(() => tasksService.setTasks(reorderedTestTasks))
          .thenThrow(exception);
      // expect later
      expectLater(
        taskListController.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          predicate<AsyncValue<void>>((value) {
            expect(value.hasError, true);
            return true;
          }),
        ]),
      );
      // run
      await taskListController.reorderTasks(
        testTasks,
        oldIndex,
        newIndex,
      );
      // verify
      verify(() => tasksService.setTasks(reorderedTestTasks)).called(1);
    });
  });
}
