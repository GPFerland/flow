import 'package:flow/src/features/tasks/domain/mutable_tasks.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils.dart';

void main() {
  group('mutable tasks', () {
    test('add task', () {
      // setup
      final existingTask = createTestTask(id: '1');
      final tasks = Tasks(tasksList: [
        existingTask,
      ]);
      final newTask = createTestTask(id: '2');
      // run
      final updatedTasks = tasks.addTask(
        newTask,
      );
      // verify
      expect(updatedTasks.tasksList.length, 2);
      expect(updatedTasks.tasksList[1].id, '2');
    });
    test('add tasks', () {
      // setup
      final existingTask = createTestTask(id: '1');
      final tasks = Tasks(tasksList: [
        existingTask,
      ]);
      final newTasks = [
        createTestTask(id: '2'),
        createTestTask(id: '3'),
      ];
      // run
      final updatedTasks = tasks.addTasks(
        newTasks,
      );
      // verify
      expect(updatedTasks.tasksList.length, 3);
      expect(updatedTasks.tasksList[1].id, '2');
      expect(updatedTasks.tasksList[2].id, '3');
    });
    test('set existing task', () {
      // setup
      final task = createTestTask(id: '1');
      final tasks = Tasks(tasksList: [
        task,
        createTestTask(id: '2'),
      ]);
      final updatedTask = task.copyWith(date: getDateNoTimeTomorrow());
      // run
      final updatedTasks = tasks.setTask(
        updatedTask,
      );
      // verify
      expect(updatedTasks.tasksList.length, 2);
      expect(updatedTasks.tasksList[0].id, '1');
      expect(updatedTasks.tasksList[0].date, getDateNoTimeTomorrow());
      expect(updatedTasks.tasksList[1].id, '2');
      expect(updatedTasks.tasksList[1].date, getDateNoTimeToday());
    });
    test('set new task', () {
      // setup
      final tasks = Tasks(tasksList: [
        createTestTask(id: '1'),
      ]);
      final newTask = createTestTask(id: '2');
      // run
      final updatedTasks = tasks.setTask(
        newTask,
      );
      // verify
      expect(updatedTasks.tasksList.length, 2);
      expect(updatedTasks.tasksList[0].id, '1');
      expect(updatedTasks.tasksList[1].id, '2');
    });
    test('remove task', () {
      // setup
      final existingTask = createTestTask(id: '1');
      final tasks = Tasks(tasksList: [
        existingTask,
      ]);
      // run
      final updatedTasks = tasks.removeTask(
        existingTask,
      );
      // verify
      expect(updatedTasks.tasksList.length, 0);
    });
  });
}
