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
  group('toggle completed', () {
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
  group('toggle skipped', () {
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
}
