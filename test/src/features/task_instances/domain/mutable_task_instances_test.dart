import 'package:flow/src/features/task_instances/domain/mutable_task_instances.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils.dart';

void main() {
  group('mutable task instances', () {
    test('add task instance', () {
      // setup
      final existingTaskInstance = createTestTaskInstance(id: '1');
      final taskInstances = TaskInstances(taskInstancesList: [
        existingTaskInstance,
      ]);
      final newTaskInstance = createTestTaskInstance(id: '2');
      // run
      final updatedTaskInstances = taskInstances.addTaskInstance(
        newTaskInstance,
      );
      // verify
      expect(updatedTaskInstances.taskInstancesList.length, 2);
      expect(updatedTaskInstances.taskInstancesList[1].id, '2');
    });
    test('add task instances', () {
      // setup
      final existingTaskInstance = createTestTaskInstance(id: '1');
      final taskInstances = TaskInstances(taskInstancesList: [
        existingTaskInstance,
      ]);
      final newTaskInstances = [
        createTestTaskInstance(id: '2'),
        createTestTaskInstance(id: '3'),
      ];
      // run
      final updatedTaskInstances = taskInstances.addTaskInstances(
        newTaskInstances,
      );
      // verify
      expect(updatedTaskInstances.taskInstancesList.length, 3);
      expect(updatedTaskInstances.taskInstancesList[1].id, '2');
      expect(updatedTaskInstances.taskInstancesList[2].id, '3');
    });
    test('set existing task instance', () {
      // setup
      final taskInstance = createTestTaskInstance(id: '1');
      final taskInstances = TaskInstances(taskInstancesList: [
        taskInstance,
        createTestTaskInstance(id: '2'),
      ]);
      final updatedTaskInstance = taskInstance.copyWith(completed: true);
      // run
      final updatedTaskInstances = taskInstances.setTaskInstance(
        updatedTaskInstance,
      );
      // verify
      expect(updatedTaskInstances.taskInstancesList.length, 2);
      expect(updatedTaskInstances.taskInstancesList[0].id, '1');
      expect(updatedTaskInstances.taskInstancesList[0].completed, true);
      expect(updatedTaskInstances.taskInstancesList[1].id, '2');
      expect(updatedTaskInstances.taskInstancesList[1].completed, false);
    });
    test('set new task instance', () {
      // setup
      final taskInstances = TaskInstances(taskInstancesList: [
        createTestTaskInstance(id: '1'),
      ]);
      final newTaskInstance = createTestTaskInstance(id: '2');
      // run
      final updatedTaskInstances = taskInstances.setTaskInstance(
        newTaskInstance,
      );
      // verify
      expect(updatedTaskInstances.taskInstancesList.length, 2);
      expect(updatedTaskInstances.taskInstancesList[0].id, '1');
      expect(updatedTaskInstances.taskInstancesList[1].id, '2');
    });
    test('remove task instance', () {
      // setup
      final existingTaskInstance = createTestTaskInstance(id: '1');
      final taskInstances = TaskInstances(taskInstancesList: [
        existingTaskInstance,
      ]);
      // run
      final updatedTaskInstances = taskInstances.removeTaskInstance(
        existingTaskInstance,
      );
      // verify
      expect(updatedTaskInstances.taskInstancesList.length, 0);
    });
    test('remove tasks instances', () {
      // setup
      const String removeTaskId = '1';
      final taskInstances = TaskInstances(taskInstancesList: [
        createTestTaskInstance().copyWith(taskId: removeTaskId),
        createTestTaskInstance().copyWith(taskId: removeTaskId),
        createTestTaskInstance().copyWith(taskId: '2'),
      ]);
      // run
      final updatedTaskInstances = taskInstances.removeTasksInstances(
        removeTaskId,
      );
      // verify
      expect(updatedTaskInstances.taskInstancesList.length, 1);
    });
    test('sort tasks instances', () {
      // setup
      final normalTask1 = createTestTaskInstance(id: '2');
      final normalTask2 = createTestTaskInstance(id: '4');
      final completedTask = createTestTaskInstance(id: '3').copyWith(
        completed: true,
      );
      final skippedTask = createTestTaskInstance(id: '1').copyWith(
        skipped: true,
      );
      final taskInstances = TaskInstances(taskInstancesList: [
        skippedTask,
        completedTask,
        normalTask2,
        normalTask1
      ]);
      final expectedTaskInstances = TaskInstances(taskInstancesList: [
        normalTask2,
        normalTask1,
        completedTask,
        skippedTask,
      ]);
      // run
      final updatedTaskInstances = taskInstances.sortTaskInstances();
      // verify
      expect(updatedTaskInstances, expectedTaskInstances);
    });
  });
}
