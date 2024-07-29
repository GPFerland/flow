import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils.dart';

void main() {
  group('reschedule', () {
    test('first time reschedule, not completed, not skipped', () {
      final taskInstance = createTestTaskInstance();
      final date = getDateNoTimeTomorrow();
      final rescheduledTaskInstance = taskInstance.reschedule(date);
      expect(rescheduledTaskInstance.rescheduledDate, date);
      expect(rescheduledTaskInstance.completed, false);
      expect(rescheduledTaskInstance.completedDate, null);
      expect(rescheduledTaskInstance.skipped, false);
      expect(rescheduledTaskInstance.skippedDate, null);
    });
    test('previously rescheduled, not completed, not skipped', () {
      final taskInstance = createTestTaskInstance().copyWith(
        rescheduledDate: () => getDateNoTimeTomorrow(),
      );
      final date = getDateNoTimeToday();
      final rescheduledTaskInstance = taskInstance.reschedule(date);
      expect(rescheduledTaskInstance.rescheduledDate, date);
      expect(rescheduledTaskInstance.completed, false);
      expect(rescheduledTaskInstance.completedDate, null);
      expect(rescheduledTaskInstance.skipped, false);
      expect(rescheduledTaskInstance.skippedDate, null);
    });
    test('first time reschedule, completed, not skipped', () {
      final taskInstance = createTestTaskInstance().copyWith(
        completed: true,
        completedDate: () => getDateNoTimeToday(),
      );
      final date = getDateNoTimeTomorrow();
      final rescheduledTaskInstance = taskInstance.reschedule(date);
      expect(rescheduledTaskInstance.rescheduledDate, date);
      expect(rescheduledTaskInstance.completed, true);
      expect(rescheduledTaskInstance.completedDate, date);
      expect(rescheduledTaskInstance.skipped, false);
      expect(rescheduledTaskInstance.skippedDate, null);
    });
    test('first time reschedule, not completed, skipped', () {
      final taskInstance = createTestTaskInstance().copyWith(
        skipped: true,
        skippedDate: () => getDateNoTimeToday(),
      );
      final date = getDateNoTimeTomorrow();
      final rescheduledTaskInstance = taskInstance.reschedule(date);
      expect(rescheduledTaskInstance.rescheduledDate, date);
      expect(rescheduledTaskInstance.completed, false);
      expect(rescheduledTaskInstance.completedDate, null);
      expect(rescheduledTaskInstance.skipped, true);
      expect(rescheduledTaskInstance.skippedDate, date);
    });
  });

  group('toggleCompleted', () {
    test('NOT completed - changed to completed, completed date set', () {
      final taskInstance = createTestTaskInstance();
      final date = getDateNoTimeToday();
      final toggledTaskInstance = taskInstance.toggleCompleted(date);
      expect(toggledTaskInstance.completed, true);
      expect(toggledTaskInstance.completedDate, date);
    });
    test('completed - changed to NOT completed, completed date cleared', () {
      final taskInstance = createTestTaskInstance().copyWith(
        completed: true,
        completedDate: () => getDateNoTimeToday(),
      );
      final date = getDateNoTimeToday();
      final toggledTaskInstance = taskInstance.toggleCompleted(date);
      expect(toggledTaskInstance.completed, false);
      expect(toggledTaskInstance.completedDate, null);
    });
  });

  group('toggleSkipped', () {
    test('NOT skipped - changed to skipped, skipped date set', () {
      final taskInstance = createTestTaskInstance();
      final date = getDateNoTimeToday();
      final toggledTaskInstance = taskInstance.toggleSkipped(date);
      expect(toggledTaskInstance.skipped, true);
      expect(toggledTaskInstance.skippedDate, date);
    });
    test('skipped - changed to NOT skipped, skipped date cleared', () {
      final taskInstance = createTestTaskInstance().copyWith(
        skipped: true,
        skippedDate: () => getDateNoTimeToday(),
      );
      final date = getDateNoTimeToday();
      final toggledTaskInstance = taskInstance.toggleSkipped(date);
      expect(toggledTaskInstance.skipped, false);
      expect(toggledTaskInstance.skippedDate, null);
    });
  });

  group('setTaskPriority', () {
    test('task priority is set to the new value', () {
      final taskInstance = createTestTaskInstance();
      const priority = 10;
      expect(taskInstance.taskPriority, 0);
      final updatedTaskInstance = taskInstance.setTaskPriority(priority);
      expect(updatedTaskInstance.taskPriority, priority);
    });
  });

  group('isDisplayed', () {
    test('overdue, return true', () {
      final taskInstance = createTestTaskInstance().copyWith(
        untilCompleted: true,
        nextInstanceOn: () => null,
        initialDate: getDateNoTimeYesterday(),
        rescheduledDate: () => null,
        completed: false,
        skipped: false,
      );
      final date = getDateNoTimeToday();
      final isDisplayed = taskInstance.isDisplayed(date);
      expect(isDisplayed, true);
    });
    test('scheduled, return true', () {
      final taskInstance = createTestTaskInstance();
      final date = getDateNoTimeToday();
      final isDisplayed = taskInstance.isDisplayed(date);
      expect(isDisplayed, true);
    });
    test('untilCompleted, before today, completed on date, return true', () {
      final taskInstance = createTestTaskInstance().copyWith(
        initialDate: getDateNoTimeYesterday().subtract(const Duration(days: 2)),
        skipped: false,
        completed: true,
        completedDate: () => getDateNoTimeYesterday(),
      );
      final date = getDateNoTimeYesterday();
      final isDisplayed = taskInstance.isDisplayed(date);
      expect(isDisplayed, true);
    });
    test('untilCompleted, before today, skipped on date, return true', () {
      final taskInstance = createTestTaskInstance().copyWith(
        initialDate: getDateNoTimeYesterday().subtract(const Duration(days: 2)),
        skipped: true,
        skippedDate: () => getDateNoTimeYesterday(),
        completed: false,
      );
      final date = getDateNoTimeYesterday();
      final isDisplayed = taskInstance.isDisplayed(date);
      expect(isDisplayed, true);
    });
    test('NOT overdue, scheduled, or completed/skipped, return false', () {
      final taskInstance = createTestTaskInstance();
      final date = getDateNoTimeYesterday();
      final isDisplayed = taskInstance.isDisplayed(date);
      expect(isDisplayed, false);
    });
  });

  group('isScheduled', () {
    test('scheduled, return true', () {
      final taskInstance = createTestTaskInstance();
      final date = getDateNoTimeToday();
      final isScheduled = taskInstance.isScheduled(date);
      expect(isScheduled, true);
    });
    test('NOT scheduled, return false', () {
      final taskInstance = createTestTaskInstance().copyWith(
        rescheduledDate: () => getDateNoTimeTomorrow(),
      );
      final date = getDateNoTimeToday();
      final isScheduled = taskInstance.isScheduled(date);
      expect(isScheduled, false);
    });
  });

  group('isOverdue', () {
    test('overdue, return true', () {
      final taskInstance = createTestTaskInstance().copyWith(
        untilCompleted: true,
        nextInstanceOn: () => null,
        initialDate: getDateNoTimeYesterday(),
        rescheduledDate: () => null,
        completed: false,
        skipped: false,
      );
      final date = getDateNoTimeToday();
      final isOverdue = taskInstance.isOverdue(date);
      expect(isOverdue, true);
    });
    test('NOT overdue, untilCompleted is false', () {
      final taskInstance = createTestTaskInstance().copyWith(
        untilCompleted: false,
      );
      final date = getDateNoTimeToday();
      final isOverdue = taskInstance.isOverdue(date);
      expect(isOverdue, false);
    });
    test('NOT overdue, date is not today OR day before next instance', () {
      final taskInstance = createTestTaskInstance().copyWith(
        untilCompleted: true,
        nextInstanceOn: () => getDateNoTimeTomorrow().add(
          const Duration(days: 5),
        ),
      );
      final date = getDateNoTimeTomorrow();
      final isOverdue = taskInstance.isOverdue(date);
      expect(isOverdue, false);
    });
    test('NOT overdue, initialDate is NOT before date', () {
      final taskInstance = createTestTaskInstance().copyWith(
        untilCompleted: true,
        nextInstanceOn: () => getDateNoTimeTomorrow(),
        initialDate: getDateNoTimeTomorrow(),
      );
      final date = getDateNoTimeToday();
      final isOverdue = taskInstance.isOverdue(date);
      expect(isOverdue, false);
    });
    test('NOT overdue, rescheduledDate is NOT before date', () {
      final taskInstance = createTestTaskInstance().copyWith(
        untilCompleted: true,
        nextInstanceOn: () => getDateNoTimeTomorrow(),
        initialDate: getDateNoTimeYesterday(),
        rescheduledDate: () => getDateNoTimeToday(),
      );
      final date = getDateNoTimeToday();
      final isOverdue = taskInstance.isOverdue(date);
      expect(isOverdue, false);
    });
    test('NOT overdue, date is NOT before nextInstanceOn', () {
      final taskInstance = createTestTaskInstance().copyWith(
        untilCompleted: true,
        nextInstanceOn: () => getDateNoTimeToday(),
        initialDate: getDateNoTimeYesterday(),
        rescheduledDate: () => null,
      );
      final date = getDateNoTimeToday();
      final isOverdue = taskInstance.isOverdue(date);
      expect(isOverdue, false);
    });
    test('NOT overdue, task is completed', () {
      final taskInstance = createTestTaskInstance().copyWith(
        untilCompleted: true,
        nextInstanceOn: () => null,
        initialDate: getDateNoTimeYesterday(),
        rescheduledDate: () => null,
        completed: true,
      );
      final date = getDateNoTimeToday();
      final isOverdue = taskInstance.isOverdue(date);
      expect(isOverdue, false);
    });
    test('NOT overdue, task is skipped', () {
      final taskInstance = createTestTaskInstance().copyWith(
        untilCompleted: true,
        nextInstanceOn: () => null,
        initialDate: getDateNoTimeYesterday(),
        rescheduledDate: () => null,
        completed: false,
        skipped: true,
      );
      final date = getDateNoTimeToday();
      final isOverdue = taskInstance.isOverdue(date);
      expect(isOverdue, false);
    });
  });
}
