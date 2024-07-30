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
      verifyNever(() => tasksService.setTasks(any()));
      verifyNever(() => taskInstancesService.setTaskInstances(any()));
    });
  });

  group('submitTask', () {
    test('success', () async {
      // setup
      final expectedTask = createTestTask();
      when(() => tasksService.setTasks([expectedTask])).thenAnswer(
        (_) => Future.value(),
      );
      when(() => taskInstancesService.updateTasksInstances(any(), any()))
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
      verify(() => tasksService.setTasks([expectedTask])).called(1);
      verify(
        () => taskInstancesService.updateTasksInstances(expectedTask, null),
      ).called(1);
    });
    test('failure', () async {
      // setup
      final expectedTask = createTestTask();
      final exception = Exception('Connection failed');
      when(() => tasksService.setTasks([expectedTask])).thenThrow(exception);
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
      verify(() => tasksService.setTasks([expectedTask])).called(1);
      verifyNever(
        () => taskInstancesService.updateTasksInstances(expectedTask, null),
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
      verifyNever(() => tasksService.setTasks(any()));
      verifyNever(() => taskInstancesService.updateTaskInstances(any(), any()));
    });
  });

  group('deleteTask', () {
    test('success', () async {
      // setup
      final expectedTask = createTestTask();
      when(() => taskInstancesService.removeTasksInstances(expectedTask.id))
          .thenAnswer(
        (_) => Future.value(),
      );
      when(() => tasksService.removeTask(expectedTask.id)).thenAnswer(
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
        () => taskInstancesService.removeTasksInstances(expectedTask.id),
      ).called(1);
      verify(
        () => tasksService.removeTask(expectedTask.id),
      ).called(1);
    });

    test('failure', () async {
      // setup
      final expectedTask = createTestTask();
      final exception = Exception('Connection failed');
      when(() => taskInstancesService.removeTasksInstances(expectedTask.id))
          .thenAnswer(
        (_) => Future.value(),
      );
      when(() => tasksService.removeTask(expectedTask.id)).thenThrow(exception);
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
        () => tasksService.removeTask(expectedTask.id),
      ).called(1);
      verify(
        () => taskInstancesService.removeTasksInstances(expectedTask.id),
      ).called(1);
    });
  });
}
