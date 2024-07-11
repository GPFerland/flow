import 'package:flow/src/features/check_list/presentation/reschedule_dialog/reschedule_form_controller.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../../../utils.dart';

void main() {
  group('rescheduleTaskInstance', () {
    test('reschedule task, success', () async {
      // setup
      final taskInstance = createTestTaskInstance();
      final rescheduledDate = getDateNoTimeTomorrow();
      final updatedTaskInstance = taskInstance.reschedule(rescheduledDate);
      final taskInstanceService = MockTaskInstancesService();
      when(() => taskInstanceService.setTaskInstance(updatedTaskInstance))
          .thenAnswer((_) => Future.value(null));
      // set initialDate to rescheduledDate to mock a user picking a new date
      final controller = RescheduleFormController(
        taskInstancesService: taskInstanceService,
        initialDate: rescheduledDate,
      );
      // run & verify
      expectLater(
        controller.stream,
        emitsInOrder([
          const AsyncLoading<DateTime>().copyWithPrevious(
            AsyncData(rescheduledDate),
          ),
        ]),
      );
      await controller.rescheduleTaskInstance(taskInstance);
      verify(
        () => taskInstanceService.setTaskInstance(updatedTaskInstance),
      ).called(1);
    });
    test('reschedule task, failure', () async {
      // setup
      final taskInstance = createTestTaskInstance();
      final rescheduledDate = getDateNoTimeTomorrow();
      final updatedTaskInstance = taskInstance.reschedule(rescheduledDate);
      final taskInstanceService = MockTaskInstancesService();
      when(() => taskInstanceService.setTaskInstance(updatedTaskInstance))
          .thenThrow((_) => Exception('Failure'));
      // set initialDate to rescheduledDate to mock a user picking a new date
      final controller = RescheduleFormController(
        taskInstancesService: taskInstanceService,
        initialDate: rescheduledDate,
      );
      // run & verify
      expectLater(
        controller.stream,
        emitsInOrder([
          const AsyncLoading<DateTime>().copyWithPrevious(
            AsyncData(rescheduledDate),
          ),
          predicate<AsyncValue<DateTime>>(
            (value) {
              expect(value.hasError, true);
              return true;
            },
          ),
        ]),
      );
      await controller.rescheduleTaskInstance(taskInstance);
      verify(
        () => taskInstanceService.setTaskInstance(updatedTaskInstance),
      ).called(1);
    });
  });

  group('skipTaskInstance', () {
    test('skip task, success', () async {
      // setup
      final taskInstance = createTestTaskInstance();
      final updatedTaskInstance = taskInstance.toggleSkipped(
        getDateNoTimeToday(),
      );
      final taskInstanceService = MockTaskInstancesService();
      when(() => taskInstanceService.setTaskInstance(updatedTaskInstance))
          .thenAnswer((_) => Future.value(null));
      final controller = RescheduleFormController(
        taskInstancesService: taskInstanceService,
        initialDate: getDateNoTimeToday(),
      );
      // run & verify
      expectLater(
        controller.stream,
        emitsInOrder([
          const AsyncLoading<DateTime>().copyWithPrevious(
            AsyncData(getDateNoTimeToday()),
          ),
        ]),
      );
      await controller.skipTaskInstance(taskInstance);
      verify(
        () => taskInstanceService.setTaskInstance(updatedTaskInstance),
      ).called(1);
    });
    test('skip task, failure', () async {
      // setup
      final taskInstance = createTestTaskInstance();
      final updatedTaskInstance = taskInstance.toggleSkipped(
        getDateNoTimeToday(),
      );
      final taskInstanceService = MockTaskInstancesService();
      when(() => taskInstanceService.setTaskInstance(updatedTaskInstance))
          .thenThrow((_) => Exception('Failure'));
      final controller = RescheduleFormController(
        taskInstancesService: taskInstanceService,
        initialDate: getDateNoTimeToday(),
      );
      // run & verify
      expectLater(
        controller.stream,
        emitsInOrder([
          const AsyncLoading<DateTime>().copyWithPrevious(
            AsyncData(getDateNoTimeToday()),
          ),
          predicate<AsyncValue<void>>(
            (value) {
              expect(value.hasError, true);
              return true;
            },
          ),
        ]),
      );
      await controller.skipTaskInstance(taskInstance);
      verify(
        () => taskInstanceService.setTaskInstance(updatedTaskInstance),
      ).called(1);
    });
  });
}
