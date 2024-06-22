import 'package:flow/src/common_widgets/primary_button.dart';
import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/date_check_list/presentation/check_list_screen/check_list_app_bar/more_menu_button.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/local/test_local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/test_remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/presentation/task_form/task_form.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list_screen/tasks_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class TasksRobot {
  TasksRobot(this.widgetTester);
  final WidgetTester widgetTester;

  Future<void> openTasksScreen() async {
    final finder = find.byKey(MoreMenuButton.tasksKey);
    expect(finder, findsOneWidget);
    await widgetTester.tap(finder);
    await widgetTester.pumpAndSettle();
  }

  Future<void> pumpTasksScreen({
    required TestAuthRepository authRepository,
    required TestLocalTasksRepository tasksRepository,
  }) {
    return widgetTester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          localTasksRepositoryProvider.overrideWithValue(tasksRepository),
        ],
        child: const MaterialApp(
          home: TasksListScreen(),
        ),
      ),
    );
  }

  // Future<void> pumpCreateTaskScreen({
  //   required TestAuthRepository authRepository,
  //   required TestLocalTasksRepository tasksRepository,
  // }) {
  //   return widgetTester.pumpWidget(
  //     ProviderScope(
  //       overrides: [
  //         authRepositoryProvider.overrideWithValue(authRepository),
  //         localTasksRepositoryProvider.overrideWithValue(tasksRepository),
  //         taskFormControllerProvider.overrideWith(
  //           (_) => MockTaskFormController,
  //         ),
  //       ],
  //       child: const MaterialApp(
  //         home: CreateTaskScreen(),
  //       ),
  //     ),
  //   );
  // }

  Future<void> pumpTaskForm({
    required TestAuthRepository authRepository,
    required TestLocalTasksRepository localTasksRepository,
    required TestRemoteTasksRepository remoteTasksRepository,
  }) {
    return widgetTester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            authRepository,
          ),
          localTasksRepositoryProvider.overrideWithValue(
            localTasksRepository,
          ),
          remoteTasksRepositoryProvider.overrideWithValue(
            remoteTasksRepository,
          ),
          tasksServiceProvider.overrideWithValue(
            TasksService(
              authRepository: authRepository,
              localTasksRepository: localTasksRepository,
              remoteTasksRepository: remoteTasksRepository,
            ),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: TaskForm(),
          ),
        ),
      ),
    );
  }

  Future<void> tapBackButton() async {
    final backButton = find.byType(IconButton);
    expect(backButton, findsOneWidget);
    await widgetTester.tap(backButton);
    await widgetTester.pumpAndSettle();
  }

  Future<void> tapAddButton() async {
    final addButton = find.byType(IconButton);
    expect(addButton, findsOneWidget);
    await widgetTester.tap(addButton);
    await widgetTester.pumpAndSettle();
  }

  Future<void> enterTitle(String title) async {
    final titleField = find.byKey(TaskForm.taskTitleKey);
    expect(titleField, findsOneWidget);
    await widgetTester.enterText(titleField, title);
  }

  void expectTitleValidationErrorFound() {
    final finder = find.text('Please add a title.');
    expect(finder, findsOneWidget);
  }

  void expectTitleValidationErrorNotFound() {
    final finder = find.text('Please add a title.');
    expect(finder, findsNothing);
  }

  Future<void> enterDescription(String description) async {
    final descriptionField = find.byKey(TaskForm.taskDescriptionKey);
    expect(descriptionField, findsOneWidget);
    await widgetTester.enterText(descriptionField, description);
  }

  Future<void> toggleUntilCompleted() async {
    final untilCompletedSlider = find.byKey(TaskForm.taskUntilCompletedKey);
    expect(untilCompletedSlider, findsOneWidget);
    await widgetTester.tap(untilCompletedSlider);
  }

  Future<void> tapCreateButton() async {
    final createButton = find.byType(PrimaryButton);
    expect(createButton, findsOneWidget);
    await widgetTester.tap(createButton);
    await widgetTester.pumpAndSettle();
  }

  void expectErrorAlertFound() {
    final finder = find.text('Error');
    expect(finder, findsOneWidget);
  }

  void expectErrorAlertNotFound() {
    final finder = find.text('Error');
    expect(finder, findsNothing);
  }

  void expectCircularProgressIndicator() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }
}
