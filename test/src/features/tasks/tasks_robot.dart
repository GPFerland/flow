import 'package:flow/src/features/date_check_list/data/date_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/presentation/task_form/task_form.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

class TasksRobot {
  TasksRobot(this.widgetTester);
  final WidgetTester widgetTester;

  Future<void> pumpTaskForm({
    required MockGoRouter goRouter,
    required MockDateRepository dateRepository,
    required MockTasksService tasksService,
    required MockTaskInstancesService taskInstancesService,
    required Task? task,
  }) {
    return widgetTester.pumpWidget(
      ProviderScope(
        overrides: [
          goRouterProvider.overrideWithValue(goRouter),
          dateRepositoryProvider.overrideWithValue(dateRepository),
          tasksServiceProvider.overrideWithValue(tasksService),
          taskInstancesServiceProvider.overrideWithValue(taskInstancesService),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: TaskForm(
              task: task,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> enterTitle(String title) async {
    final titleField = find.byKey(TaskForm.taskTitleKey);
    expect(titleField, findsOneWidget);
    await widgetTester.enterText(titleField, title);
  }

  Future<void> enterDescription(String description) async {
    final descriptionField = find.byKey(TaskForm.taskDescriptionKey);
    expect(descriptionField, findsOneWidget);
    await widgetTester.enterText(descriptionField, description);
  }

  void expectFindTaskListCard(Task task) {
    final finder = find.text(task.title);
    expect(finder, findsOneWidget);
  }

  void expectTitleValidationErrorFound() {
    final finder = find.text('Please add a title.');
    expect(finder, findsOneWidget);
  }

  void expectTitleValidationErrorNotFound() {
    final finder = find.text('Please add a title.');
    expect(finder, findsNothing);
  }

  void expectErrorAlertFound() {
    final finder = find.text('Error');
    expect(finder, findsOneWidget);
  }

  void expectErrorAlertNotFound() {
    final finder = find.text('Error');
    expect(finder, findsNothing);
  }

  void expectCircularProgressIndicatorFound() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }
}
