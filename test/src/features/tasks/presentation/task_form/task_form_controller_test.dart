@Timeout(Duration(milliseconds: 500))
library;

import 'package:flow/src/features/tasks/presentation/task_form/task_form_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../../../utils.dart';

void main() {
  late MockTasksService tasksService;
  late MockTaskInstancesService taskInstancesService;
  late TaskFormController taskFormController;

  setUpAll(() {
    registerFallbackValue(createTestTask());
  });

  setUp(() {
    tasksService = MockTasksService();
    taskInstancesService = MockTaskInstancesService();
    taskFormController = TaskFormController(
      tasksService: tasksService,
      taskInstancesService: taskInstancesService,
    );
  });

  group('TaskFormController', () {
    test('initial state is AsyncValue.data', () {
      verifyNever(() => tasksService.setTask(any()));
      expect(taskFormController.state, const AsyncData<void>(null));
    });

    test('submitTask success', () async {
      // setup
      final expectedTask = createTestTask();
      when(() => tasksService.setTask(expectedTask)).thenAnswer(
        (_) => Future.value(),
      );
      // expect later
      expectLater(
        taskFormController.stream,
        emitsInOrder(const [
          AsyncLoading<void>(),
        ]),
      );
      // run
      bool result = await taskFormController.submitTask(expectedTask);
      // verify
      expect(result, true);
      verify(() => tasksService.setTask(expectedTask)).called(1);
    });

    test('submitTask failure', () async {
      // setup
      final expectedTask = createTestTask();
      final exception = Exception('Connection failed');
      when(() => tasksService.setTask(expectedTask)).thenThrow(exception);
      // expect later
      expectLater(
        taskFormController.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          predicate<AsyncValue<void>>((value) {
            expect(value.hasError, true);
            return true;
          }),
        ]),
      );
      // run
      bool result = await taskFormController.submitTask(expectedTask);
      // verify
      expect(result, false);
      verify(() => tasksService.setTask(expectedTask)).called(1);
    });

    test('deleteTask success', () async {
      // setup
      final expectedTask = createTestTask();
      when(() => tasksService.removeTask(expectedTask)).thenAnswer(
        (_) => Future.value(),
      );
      // expect later
      expectLater(
        taskFormController.stream,
        emitsInOrder(const [
          AsyncLoading<void>(),
        ]),
      );
      // run
      bool result = await taskFormController.deleteTask(expectedTask);
      // verify
      expect(result, true);
      verify(() => tasksService.removeTask(expectedTask)).called(1);
    });

    test('deleteTask failure', () async {
      // setup
      final expectedTask = createTestTask();
      final exception = Exception('Connection failed');
      when(() => tasksService.removeTask(expectedTask)).thenThrow(exception);
      // expect later
      expectLater(
        taskFormController.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          predicate<AsyncValue<void>>((value) {
            expect(value.hasError, true);
            return true;
          }),
        ]),
      );
      // run
      bool result = await taskFormController.deleteTask(expectedTask);
      // verify
      expect(result, false);
      verify(() => tasksService.removeTask(expectedTask)).called(1);
    });

    test('deleteTaskInstances success', () async {
      // setup
      final expectedTask = createTestTask();
      when(
        () => taskInstancesService.removeTasksInstances(expectedTask.id),
      ).thenAnswer(
        (_) => Future.value(),
      );
      // expect later
      expectLater(
        taskFormController.stream,
        emitsInOrder(const [
          AsyncLoading<void>(),
        ]),
      );
      // run
      bool result = await taskFormController.deleteTasksInstances(expectedTask);
      // verify
      expect(result, true);
      verify(
        () => taskInstancesService.removeTasksInstances(expectedTask.id),
      ).called(1);
    });

    test('deleteTaskInstances failure', () async {
      // setup
      final expectedTask = createTestTask();
      final exception = Exception('Connection failed');
      when(
        () => taskInstancesService.removeTasksInstances(expectedTask.id),
      ).thenThrow(exception);
      // expect later
      expectLater(
        taskFormController.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          predicate<AsyncValue<void>>((value) {
            expect(value.hasError, true);
            return true;
          }),
        ]),
      );
      // run
      bool result = await taskFormController.deleteTasksInstances(expectedTask);
      // verify
      expect(result, false);
      verify(
        () => taskInstancesService.removeTasksInstances(expectedTask.id),
      ).called(1);
    });
  });
}
