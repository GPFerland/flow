@Timeout(Duration(milliseconds: 500))
library;

import 'package:flow/src/features/tasks/presentation/task/task_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../../../utils.dart';

void main() {
  late MockTasksService tasksService;
  late MockTaskInstancesService taskInstancesService;
  late TaskController taskController;

  setUp(() {
    registerFallbackValue(createTestTask());
    tasksService = MockTasksService();
    taskInstancesService = MockTaskInstancesService();
    taskController = TaskController(
      tasksService: tasksService,
      taskInstancesService: taskInstancesService,
    );
  });

  group('TaskController', () {
    test('initial state is AsyncValue.data', () {
      verifyNever(() => tasksService.setTasks(any()));
      expect(taskController.state, const AsyncData<void>(null));
    });

    test('submitTask success', () async {
      // setup
      final expectedTask = createTestTask();
      when(() => tasksService.setTasks([expectedTask])).thenAnswer(
        (_) => Future.value(),
      );
      when(() => taskInstancesService.updateTasksInstances(any(), any()))
          .thenAnswer(
        (invocation) => Future.value(),
      );
      // expect later
      expectLater(
        taskController.stream,
        emitsInOrder(const [
          AsyncLoading<void>(),
          AsyncData<void>(null),
        ]),
      );
      // run
      await taskController.submitTask(
        task: expectedTask,
        oldTask: null,
        onSuccess: () {},
      );
      // verify
      verify(() => tasksService.setTasks([expectedTask])).called(1);
    });

    test('submitTask failure', () async {
      // setup
      final expectedTask = createTestTask();
      final exception = Exception('Connection failed');
      when(() => tasksService.setTasks([expectedTask])).thenThrow(exception);
      // expect later
      expectLater(
        taskController.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          predicate<AsyncValue<void>>((value) {
            expect(value.hasError, true);
            return true;
          }),
        ]),
      );
      // run
      await taskController.submitTask(
        task: expectedTask,
        oldTask: null,
        onSuccess: () {},
      );
      // verify
      verify(() => tasksService.setTasks([expectedTask])).called(1);
    });

    test('submitTask no change', () async {
      // setup
      final expectedTask = createTestTask();
      // run
      await taskController.submitTask(
        task: expectedTask,
        oldTask: expectedTask.copyWith(),
        onSuccess: () {},
      );
      // verify
      verifyNever(() => tasksService.setTasks(any()));
      verifyNever(() => taskInstancesService.setTaskInstances(any()));
    });

    test('deleteTask success', () async {
      // setup
      final expectedTask = createTestTask();
      when(() => taskInstancesService.removeTasksInstances(expectedTask.id))
          .thenAnswer(
        (_) => Future.value(),
      );
      when(() => tasksService.removeTask(expectedTask.id)).thenAnswer(
        (_) => Future.value(),
      );
      // expect later
      expectLater(
        taskController.stream,
        emitsInOrder(const [
          AsyncLoading<void>(),
          AsyncData<void>(null),
        ]),
      );
      // run
      await taskController.deleteTask(
        taskId: expectedTask.id,
        onSuccess: () {},
      );
      // verify
      verify(
        () => taskInstancesService.removeTasksInstances(expectedTask.id),
      ).called(1);
      verify(
        () => tasksService.removeTask(expectedTask.id),
      ).called(1);
    });

    test('deleteTask failure', () async {
      // setup
      final expectedTask = createTestTask();
      final exception = Exception('Connection failed');
      when(() => taskInstancesService.removeTasksInstances(expectedTask.id))
          .thenAnswer(
        (_) => Future.value(),
      );
      when(() => tasksService.removeTask(expectedTask.id)).thenThrow(exception);
      // expect later
      expectLater(
        taskController.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          predicate<AsyncValue<void>>((value) {
            expect(value.hasError, true);
            return true;
          }),
        ]),
      );
      // run
      await taskController.deleteTask(
        taskId: expectedTask.id,
        onSuccess: () {},
      );
      // verify
      verify(
        () => tasksService.removeTask(expectedTask.id),
      ).called(1);
      verify(
        () => taskInstancesService.removeTasksInstances(expectedTask.id),
      ).called(1);
    });
  });
}
