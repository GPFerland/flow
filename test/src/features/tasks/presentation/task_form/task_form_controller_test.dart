@Timeout(Duration(milliseconds: 500))
library;

import 'package:flow/src/features/tasks/presentation/task_screen/task_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../../../utils.dart';

void main() {
  late MockTasksService tasksService;
  late MockTaskInstancesService taskInstancesService;
  late MockDateRepository dateRepository;
  late TaskController taskFormController;

  setUpAll(() {
    registerFallbackValue(createTestTask());
  });

  setUp(() {
    tasksService = MockTasksService();
    taskInstancesService = MockTaskInstancesService();
    dateRepository = MockDateRepository();
    taskFormController = TaskController(
      tasksService: tasksService,
      taskInstancesService: taskInstancesService,
      dateRepository: dateRepository,
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
      await taskFormController.submitTask(
        task: expectedTask,
        oldTask: null,
        onSuccess: () {},
      );
      // verify
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
      await taskFormController.submitTask(
        task: expectedTask,
        oldTask: null,
        onSuccess: () {},
      );
      // verify
      verify(() => tasksService.setTask(expectedTask)).called(1);
    });

    test('deleteTask success', () async {
      // setup
      final expectedTask = createTestTask();
      when(() => tasksService.removeTask(expectedTask.id)).thenAnswer(
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
      await taskFormController.deleteTask(
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

    test('deleteTask failure', () async {
      // setup
      final expectedTask = createTestTask();
      final exception = Exception('Connection failed');
      when(() => tasksService.removeTask(expectedTask.id)).thenThrow(exception);
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
      await taskFormController.deleteTask(
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
