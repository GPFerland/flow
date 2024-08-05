import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/check_list/data/task_display_repository.dart';
import 'package:flow/src/features/check_list/presentation/check_list_controller.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

void main() {
  late MockDateRepository dateRepository;
  late MockTaskDisplayRepository taskDisplayRepository;
  late MockTasksService tasksService;
  late MockTaskInstancesService taskInstancesService;
  late ProviderContainer container;
  late Listener<AsyncValue<void>> listener;

  ProviderContainer makeProviderContainer(
    MockDateRepository dateRepository,
    MockTaskDisplayRepository taskDisplayRepository,
    MockTasksService tasksService,
    MockTaskInstancesService taskInstancesService,
  ) {
    final container = ProviderContainer(
      overrides: [
        dateRepositoryProvider.overrideWithValue(dateRepository),
        taskDisplayRepositoryProvider.overrideWithValue(taskDisplayRepository),
        tasksServiceProvider.overrideWithValue(tasksService),
        taskInstancesServiceProvider.overrideWithValue(taskInstancesService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    registerFallbackValue(const AsyncLoading<void>());
    dateRepository = MockDateRepository();
    taskDisplayRepository = MockTaskDisplayRepository();
    tasksService = MockTasksService();
    taskInstancesService = MockTaskInstancesService();
    container = makeProviderContainer(
      dateRepository,
      taskDisplayRepository,
      tasksService,
      taskInstancesService,
    );
    listener = Listener<AsyncValue<void>>();
    // listen to the provider and call [listener] whenever its value changes
    container.listen(
      checkListControllerProvider,
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
    });
  });

  group('rescheduleTaskInstance', () {
    test('success', () async {
      // setup
      final taskInstance = createTestTaskInstance();
      final rescheduledDate = getDateNoTimeTomorrow();
      final updatedTaskInstance = taskInstance.reschedule(rescheduledDate);
      when(
        () => taskInstancesService.updateTaskInstance(updatedTaskInstance),
      ).thenAnswer((_) => Future.value(null));
      // sto
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      final controller = container.read(checkListControllerProvider.notifier);
      await controller.rescheduleTaskInstance(
        newDate: rescheduledDate,
        taskInstance: taskInstance,
        onRescheduled: () {},
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
        () => taskInstancesService.updateTaskInstance(updatedTaskInstance),
      ).called(1);
    });
    test('failure', () async {
      // setup
      final taskInstance = createTestTaskInstance();
      final rescheduledDate = getDateNoTimeTomorrow();
      final updatedTaskInstance = taskInstance.reschedule(rescheduledDate);
      when(
        () => taskInstancesService.updateTaskInstance(updatedTaskInstance),
      ).thenThrow((_) => Exception('Failure'));
      // sto
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      final controller = container.read(checkListControllerProvider.notifier);
      await controller.rescheduleTaskInstance(
        newDate: rescheduledDate,
        taskInstance: taskInstance,
        onRescheduled: () {},
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
      verify(
        () => taskInstancesService.updateTaskInstance(updatedTaskInstance),
      ).called(1);
    });
  });

  group('skipTaskInstance', () {
    test('success', () async {
      // setup
      final today = getDateNoTimeToday();
      final taskInstance = createTestTaskInstance();
      final updatedTaskInstance = taskInstance.toggleSkipped(today);
      when(
        () => taskInstancesService.updateTaskInstance(updatedTaskInstance),
      ).thenAnswer((_) => Future.value(null));
      when(() => dateRepository.date).thenAnswer((_) => today);
      // sto
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      final controller = container.read(checkListControllerProvider.notifier);
      await controller.skipTaskInstance(
        taskInstance: taskInstance,
        onSkipped: () {},
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
        () => taskInstancesService.updateTaskInstance(updatedTaskInstance),
      ).called(1);
    });
    test('failure', () async {
      // setup
      final today = getDateNoTimeToday();
      final taskInstance = createTestTaskInstance();
      final updatedTaskInstance = taskInstance.toggleSkipped(today);
      final taskInstancesService = MockTaskInstancesService();
      when(
        () => taskInstancesService.updateTaskInstance(updatedTaskInstance),
      ).thenThrow((_) => Exception('Failure'));
      when(() => dateRepository.date).thenAnswer((_) => today);
      // sto
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      final controller = container.read(checkListControllerProvider.notifier);
      await controller.skipTaskInstance(
        taskInstance: taskInstance,
        onSkipped: () {},
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
      verify(
        () => taskInstancesService.updateTaskInstance(updatedTaskInstance),
      ).called(1);
    });
  });
}
