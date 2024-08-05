import 'package:flow/src/common_widgets/alert_dialogs.dart';
import 'package:flow/src/common_widgets/buttons/add_item_icon_button.dart';
import 'package:flow/src/common_widgets/buttons/custom_text_button.dart';
import 'package:flow/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flow/src/features/check_list/presentation/app_bar/check_list_app_bar.dart';
import 'package:flow/src/features/task_instances/application/task_instances_creation_service.dart';
import 'package:flow/src/features/task_instances/application/task_instances_sync_service.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository_fake.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository_fake.dart';
import 'package:flow/src/features/tasks/application/tasks_sync_service.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository_fake.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository_fake.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/flow_app.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/authentication/auth_robot.dart';
import 'features/check_list/check_list_robot.dart';
import 'features/tasks/tasks_robot.dart';

class Robot {
  Robot(this.widgetTester)
      : authRobot = AuthRobot(widgetTester),
        tasksRobot = TasksRobot(widgetTester),
        checkListRobot = CheckListRobot(widgetTester);

  final WidgetTester widgetTester;
  final AuthRobot authRobot;
  final TasksRobot tasksRobot;
  final CheckListRobot checkListRobot;

  // pump the app
  Future<void> pumpFlowApp() async {
    // Override repositories
    final authRepository = FakeAuthRepository(
      addDelay: false,
    );
    final localTasksRepository = FakeLocalTasksRepository(
      addDelay: false,
    );
    final remoteTasksRepository = FakeRemoteTasksRepository(
      addDelay: false,
    );
    final localTaskInstancesRepository = FakeLocalTaskInstancesRepository(
      addDelay: false,
    );
    final remoteTaskInstancesRepository = FakeRemoteTaskInstancesRepository(
      addDelay: false,
    );
    // Override the required providers
    final providerContainer = ProviderContainer(
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
  Future<void> signInFromCheckList() async {
    await checkListRobot.openPopupMenu();
    await tapKey(CheckListAppBar.signInMenuButtonKey);
    await authRobot.enterEmail('test@email.com');
    await authRobot.enterPassword('password');
    await tapText('Sign in');
  }

  Future<void> createAccountFromCheckList() async {
    await checkListRobot.openPopupMenu();
    await tapKey(CheckListAppBar.signInMenuButtonKey);
    await tapType(CustomTextButton);
    await authRobot.enterEmail('test@email.com');
    await authRobot.enterPassword('password');
    await tapText('Create an account');
  }

  Future<void> logoutFromCheckList() async {
    await checkListRobot.openPopupMenu();
    await tapKey(CheckListAppBar.accountMenuButtonKey);
    await tapText('Logout');
    await tapKey(kDialogDefaultKey);
  }

  Future<void> createTaskFromCheckList(Task task) async {
    await goToTaskScreenFromCheckList();
    await tasksRobot.enterTitle(task.title);
    switch (task.frequency) {
      case Frequency.once:
        await tapKey(Frequency.once.tabKey);
      case Frequency.daily:
        await tapKey(Frequency.daily.tabKey);
      case Frequency.weekly:
        await tapKey(Frequency.weekly.tabKey);
      case Frequency.monthly:
        await tapKey(Frequency.monthly.tabKey);
    }
    await tapText('Create');
    await goBack();
  }

  Future<void> goToTaskScreenFromCheckList() async {
    await checkListRobot.openPopupMenu();
    await tapKey(CheckListAppBar.tasksMenuButtonKey);
    await tapType(AddItemIconButton);
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

  Future<void> tapIcon(IconData icon) async {
    final finder = find.widgetWithIcon(IconButton, icon);
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
