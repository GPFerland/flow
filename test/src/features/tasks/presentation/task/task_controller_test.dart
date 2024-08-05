@Timeout(Duration(milliseconds: 500))
library;

import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/presentation/task/task_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../../../utils.dart';

void main() {
  late MockTasksService tasksService;
  late MockTaskInstancesService taskInstancesService;
  late ProviderContainer container;
  late Listener<AsyncValue<void>> listener;

  ProviderContainer makeProviderContainer(
    MockTasksService tasksService,
    MockTaskInstancesService taskInstancesService,
  ) {
    final container = ProviderContainer(
      overrides: [
        tasksServiceProvider.overrideWithValue(tasksService),
        taskInstancesServiceProvider.overrideWithValue(taskInstancesService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    registerFallbackValue(createTestTask());
    registerFallbackValue(const AsyncLoading<void>());
    tasksService = MockTasksService();
    taskInstancesService = MockTaskInstancesService();
    container = makeProviderContainer(
      tasksService,
      taskInstancesService,
    );
    listener = Listener<AsyncValue<void>>();
    // listen to the provider and call [listener] whenever its value changes
    container.listen(
      taskControllerProvider,
      listener.call,
      fireImmediately: true,
    );
  });

  group('initialization', () {
    test('initial state is AsyncData', () {
      // verify
      verify(
        // the build method retuns a value immediately, so we expect AsyncData
        () => listener(null, const AsyncData<void>(null)),
      );
      // verify that the listener is no longer called
      verifyNoMoreInteractions(listener);
      // verify that no repository calls during initialization
      verifyNever(() => tasksService.updateTasks(any()));
      verifyNever(() => taskInstancesService.updateTaskInstances(any()));
    });
  });

  group('submitTask', () {
    test('success', () async {
      // setup
      final expectedTask = createTestTask();
      when(() => tasksService.updateTasks([expectedTask])).thenAnswer(
        (_) => Future.value(),
      );
      when(() => taskInstancesService.changeTasksInstances(any(), any()))
          .thenAnswer(
        (invocation) => Future.value(),
      );
      // sto
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      final controller = container.read(taskControllerProvider.notifier);
      await controller.submitTask(
        task: expectedTask,
        oldTask: null,
        onSuccess: () {},
      );
      // verify
      verifyInOrder([
        // set loading state
        // * use a matcher since AsyncLoading != AsyncLoading with data
        // * https://codewithandrea.com/articles/unit-test-async-notifier-riverpod/
        () => listener(data, any(that: isA<AsyncLoading>())),
        // data when complete
        () => listener(any(that: isA<AsyncLoading>()), data),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => tasksService.updateTasks([expectedTask])).called(1);
      verify(
        () => taskInstancesService.changeTasksInstances(expectedTask, null),
      ).called(1);
    });
    test('failure', () async {
      // setup
      final expectedTask = createTestTask();
      final exception = Exception('Connection failed');
      when(() => tasksService.updateTasks([expectedTask])).thenThrow(exception);
      // sto
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      final controller = container.read(taskControllerProvider.notifier);
      await controller.submitTask(
        task: expectedTask,
        oldTask: null,
        onSuccess: () {},
      );
      // verify
      verifyInOrder([
        // set loading state
        // * use a matcher since AsyncLoading != AsyncLoading with data
        // * https://codewithandrea.com/articles/unit-test-async-notifier-riverpod/
        () => listener(data, any(that: isA<AsyncLoading>())),
        // data when complete
        () => listener(
              any(that: isA<AsyncLoading>()),
              any(that: isA<AsyncError>()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => tasksService.updateTasks([expectedTask])).called(1);
      verifyNever(
        () => taskInstancesService.changeTasksInstances(expectedTask, null),
      );
    });
    test('no change', () async {
      // setup
      final expectedTask = createTestTask();
      // sto
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      final controller = container.read(taskControllerProvider.notifier);
      await controller.submitTask(
        task: expectedTask,
        oldTask: expectedTask.copyWith(),
        onSuccess: () {},
      );
      // verify
      verifyNever(() => tasksService.updateTasks(any()));
      verifyNever(
        () => taskInstancesService.changeTasksInstances(
          any(),
          any(),
        ),
      );
    });
  });

  group('deleteTask', () {
    test('success', () async {
      // setup
      final expectedTask = createTestTask();
      when(() => taskInstancesService.deleteTasksInstances(expectedTask.id))
          .thenAnswer(
        (_) => Future.value(),
      );
      when(() => tasksService.deleteTask(expectedTask.id)).thenAnswer(
        (_) => Future.value(),
      );
      // sto
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      final controller = container.read(taskControllerProvider.notifier);
      await controller.deleteTask(
        taskId: expectedTask.id,
        onSuccess: () {},
      );
      // verify
      verifyInOrder([
        // set loading state
        // * use a matcher since AsyncLoading != AsyncLoading with data
        // * https://codewithandrea.com/articles/unit-test-async-notifier-riverpod/
        () => listener(data, any(that: isA<AsyncLoading>())),
        // data when complete
        () => listener(any(that: isA<AsyncLoading>()), data),
      ]);
      verifyNoMoreInteractions(listener);
      verify(
        () => taskInstancesService.deleteTasksInstances(expectedTask.id),
      ).called(1);
      verify(
        () => tasksService.deleteTask(expectedTask.id),
      ).called(1);
    });

    test('failure', () async {
      // setup
      final expectedTask = createTestTask();
      final exception = Exception('Connection failed');
      when(() => taskInstancesService.deleteTasksInstances(expectedTask.id))
          .thenAnswer(
        (_) => Future.value(),
      );
      when(() => tasksService.deleteTask(expectedTask.id)).thenThrow(exception);
      // sto
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      final controller = container.read(taskControllerProvider.notifier);
      await controller.deleteTask(
        taskId: expectedTask.id,
        onSuccess: () {},
      );
      // verify
      verifyInOrder([
        // set loading state
        // * use a matcher since AsyncLoading != AsyncLoading with data
        // * https://codewithandrea.com/articles/unit-test-async-notifier-riverpod/
        () => listener(data, any(that: isA<AsyncLoading>())),
        // data when complete
        () => listener(
              any(that: isA<AsyncLoading>()),
              any(that: isA<AsyncError>()),
            ),
      ]);
      verify(
        () => tasksService.deleteTask(expectedTask.id),
      ).called(1);
      verify(
        () => taskInstancesService.deleteTasksInstances(expectedTask.id),
      ).called(1);
    });
  });
}
