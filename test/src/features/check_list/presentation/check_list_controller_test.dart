import 'package:flow/src/features/check_list/presentation/check_list_controller.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

void main() {
  late CheckListController controller;
  late MockDateRepository dateRepository;
  late MockTaskVisibilityRepository taskVisibilityRepository;
  late MockTasksService tasksService;
  late MockTaskInstancesService taskInstanceService;

  setUp(() {
    taskVisibilityRepository = MockTaskVisibilityRepository();
    dateRepository = MockDateRepository();
    tasksService = MockTasksService();
    taskInstanceService = MockTaskInstancesService();
    controller = CheckListController(
      dateRepository: dateRepository,
      taskVisibilityRepository: taskVisibilityRepository,
      tasksService: tasksService,
      taskInstancesService: taskInstanceService,
    );
  });

  group('rescheduleTaskInstance', () {
    test('reschedule task, success', () async {
      // setup
      final taskInstance = createTestTaskInstance();
      final rescheduledDate = getDateNoTimeTomorrow();
      final updatedTaskInstance = taskInstance.reschedule(rescheduledDate);
      when(
        () => taskInstanceService.setTaskInstances([updatedTaskInstance]),
      ).thenAnswer((_) => Future.value(null));
      // run & verify
      expectLater(
        controller.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
        ]),
      );
      await controller.rescheduleTaskInstance(
        newDate: rescheduledDate,
        taskInstance: taskInstance,
        onRescheduled: () {},
      );
      verify(
        () => taskInstanceService.setTaskInstances([updatedTaskInstance]),
      ).called(1);
    });
    test('reschedule task, failure', () async {
      // setup
      final taskInstance = createTestTaskInstance();
      final rescheduledDate = getDateNoTimeTomorrow();
      final updatedTaskInstance = taskInstance.reschedule(rescheduledDate);
      when(
        () => taskInstanceService.setTaskInstances([updatedTaskInstance]),
      ).thenThrow((_) => Exception('Failure'));
      // run & verify
      expectLater(
        controller.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          predicate<AsyncValue<void>>(
            (value) {
              expect(value.hasError, true);
              return true;
            },
          ),
        ]),
      );
      await controller.rescheduleTaskInstance(
        newDate: rescheduledDate,
        taskInstance: taskInstance,
        onRescheduled: () {},
      );
      verify(
        () => taskInstanceService.setTaskInstances([updatedTaskInstance]),
      ).called(1);
    });
  });

  group('skipTaskInstance', () {
    test('skip task, success', () async {
      // setup
      final today = getDateNoTimeToday();
      final taskInstance = createTestTaskInstance();
      final updatedTaskInstance = taskInstance.toggleSkipped(today);
      when(
        () => taskInstanceService.setTaskInstances([updatedTaskInstance]),
      ).thenAnswer((_) => Future.value(null));
      when(() => dateRepository.date).thenAnswer((_) => today);
      // run & verify
      expectLater(
        controller.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
        ]),
      );
      await controller.skipTaskInstance(
        taskInstance: taskInstance,
        onSkipped: () {},
      );
      verify(
        () => taskInstanceService.setTaskInstances([updatedTaskInstance]),
      ).called(1);
    });
    test('skip task, failure', () async {
      // setup
      final today = getDateNoTimeToday();
      final taskInstance = createTestTaskInstance();
      final updatedTaskInstance = taskInstance.toggleSkipped(today);
      final taskInstanceService = MockTaskInstancesService();
      when(
        () => taskInstanceService.setTaskInstances([updatedTaskInstance]),
      ).thenThrow((_) => Exception('Failure'));
      when(() => dateRepository.date).thenAnswer((_) => today);
      // run & verify
      expectLater(
        controller.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          predicate<AsyncValue<void>>(
            (value) {
              expect(value.hasError, true);
              return true;
            },
          ),
        ]),
      );
      await controller.skipTaskInstance(
        taskInstance: taskInstance,
        onSkipped: () {},
      );
    });
  });
}
