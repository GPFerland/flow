import 'package:flow/src/common_widgets/alert_dialogs.dart';
import 'package:flow/src/common_widgets/buttons/add_item_icon_button.dart';
import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/date_check_list/presentation/date_app_bar/date_app_bar.dart';
import 'package:flow/src/features/task_instances/application/task_instances_creation_service.dart';
import 'package:flow/src/features/task_instances/application/task_instances_sync_service.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/local/test_local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/test_remote_task_instances_repository.dart';
import 'package:flow/src/features/tasks/application/tasks_sync_service.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/local/test_local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/test_remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/flow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/authentication/auth_robot.dart';
import 'features/date_check_list/date_check_list_robot.dart';
import 'features/tasks/tasks_robot.dart';

class Robot {
  Robot(this.widgetTester)
      : authRobot = AuthRobot(widgetTester),
        tasksRobot = TasksRobot(widgetTester),
        dateCheckListRobot = DateCheckListRobot(widgetTester);
  final WidgetTester widgetTester;
  final AuthRobot authRobot;
  final TasksRobot tasksRobot;
  final DateCheckListRobot dateCheckListRobot;

  Future<void> pumpFlowApp() async {
    // Override repositories
    final authRepository = TestAuthRepository();
    final localTasksRepository = TestLocalTasksRepository();
    final remoteTasksRepository = TestRemoteTasksRepository();
    final localTaskInstancesRepository = TestLocalTaskInstancesRepository();
    final remoteTaskInstancesRepository = TestRemoteTaskInstancesRepository();
    // Override the required providers
    final providerContainer = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        localTasksRepositoryProvider.overrideWithValue(
          localTasksRepository,
        ),
        remoteTasksRepositoryProvider.overrideWithValue(
          remoteTasksRepository,
        ),
        localTaskInstancesRepositoryProvider.overrideWithValue(
          localTaskInstancesRepository,
        ),
        remoteTaskInstancesRepositoryProvider.overrideWithValue(
          remoteTaskInstancesRepository,
        ),
      ],
    );
    // Initialize Sync listeners
    providerContainer.read(tasksSyncServiceProvider);
    providerContainer.read(taskInstancesSyncServiceProvider);
    providerContainer.read(taskInstancesCreationServiceProvider);
    // Entry point of the app
    await widgetTester.pumpWidget(
      UncontrolledProviderScope(
        container: providerContainer,
        child: const FlowApp(),
      ),
    );
    await widgetTester.pumpAndSettle();
  }

  // flows
  Future<void> signInFromDateCheckList() async {
    await dateCheckListRobot.openPopupMenu();
    await tapKey(DateAppBar.signInMenuButtonKey);
    await authRobot.enterEmail('test@email.com');
    await authRobot.enterPassword('password');
    await tapText('Submit');
  }

  Future<void> logoutFromDateCheckList() async {
    await dateCheckListRobot.openPopupMenu();
    await tapKey(DateAppBar.accountMenuButtonKey);
    await tapText('Logout');
    await tapKey(kDialogDefaultKey);
  }

  Future<void> createTaskFromDateCheckList(Task task) async {
    await goToCreateTaskFromDateCheckList();
    await tasksRobot.enterTitle(task.title);
    await tasksRobot.enterDescription(task.description);
    await tapText('Submit');
    await goBack();
  }

  Future<void> goToCreateTaskFromDateCheckList() async {
    await dateCheckListRobot.openPopupMenu();
    await tapKey(DateAppBar.tasksMenuButtonKey);
    await tapType(AddItemIconButton);
  }

  Future<void> rescheduleTask(String taskTitle, String date) async {
    await tapText(taskTitle);
    await tapText('Scheduled');
    await tapText(date);
    await tapText('OK');
    await tapText('Save');
  }

  Future<void> skipTask(String taskTitle) async {
    await tapText(taskTitle);
    await tapText('Skip');
  }

  // basic actions
  Future<void> closePage() async {
    await tapTooltip('Close');
  }

  Future<void> goBack() async {
    await tapTooltip('Back');
  }

  // generic actions
  Future<void> tapText(String text) async {
    final finder = find.text(text);
    expect(finder, findsOneWidget);
    await widgetTester.tap(finder);
    await widgetTester.pumpAndSettle();
  }

  Future<void> tapTooltip(String tooltip) async {
    final finder = find.byTooltip(tooltip);
    expect(finder, findsOneWidget);
    await widgetTester.tap(finder);
    await widgetTester.pumpAndSettle();
  }

  Future<void> tapKey(Key key) async {
    final finder = find.byKey(key);
    expect(finder, findsOneWidget);
    await widgetTester.tap(finder);
    await widgetTester.pumpAndSettle();
  }

  Future<void> tapType(Type type) async {
    final finder = find.byType(type);
    expect(finder, findsOneWidget);
    await widgetTester.tap(finder);
    await widgetTester.pumpAndSettle();
  }

  Future<void> longPressText(String text) async {
    final finder = find.text(text);
    expect(finder, findsOneWidget);
    await widgetTester.longPress(finder);
    await widgetTester.pumpAndSettle();
  }
}
