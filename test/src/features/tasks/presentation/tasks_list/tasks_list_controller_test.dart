@Timeout(Duration(milliseconds: 500))
library;

import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list/tasks_list_controller.dart';
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
      tasksListControllerProvider,
      listener.call,
      fireImmediately: true,
    );
  });

  group('TasksListController', () {
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

    group('reorderTasks', () {
      test('success', () async {
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
        // sto
        const data = AsyncData<void>(null);
        // verify initial value from build method
        verify(() => listener(null, data));
        // run
        final controller = container.read(tasksListControllerProvider.notifier);
        await controller.reorderTasks(
          testTasks,
          oldIndex,
          newIndex,
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
        verify(() => tasksService.setTasks(reorderedTestTasks)).called(1);
        verify(() => taskInstancesService.updateTaskInstancesPriority(
              reorderedTestTasks,
            )).called(1);
      });

      test('failure', () async {
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
        // sto
        const data = AsyncData<void>(null);
        // verify initial value from build method
        verify(() => listener(null, data));
        // run
        final controller = container.read(tasksListControllerProvider.notifier);
        await controller.reorderTasks(
          testTasks,
          oldIndex,
          newIndex,
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
        verify(() => tasksService.setTasks(reorderedTestTasks)).called(1);
      });
    });
  });
}
