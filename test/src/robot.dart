import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/date_check_list/presentation/check_list_app_bar/more_menu_button.dart';
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
    final authRepository = TestAuthRepository(addDelay: false);
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
    // Entry point of the app
    await widgetTester.pumpWidget(
      UncontrolledProviderScope(
        container: providerContainer,
        child: const FlowApp(),
      ),
    );
    await widgetTester.pumpAndSettle();
  }

  Future<void> openPopupMenu() async {
    final finder = find.byType(MoreMenuButton);
    final matches = finder.evaluate();
    // if an item is found, it means that we're running
    // on a small window and can tap to reveal the menu
    if (matches.isNotEmpty) {
      await widgetTester.tap(finder);
      await widgetTester.pumpAndSettle();
    }
    // else no-op, as the items are already visible
  }

  Future<void> createTaskFromDateCheckListScreen(Task task) async {
    await openPopupMenu();
    await tasksRobot.openTasksScreen();
    await tasksRobot.tapAddButton();
    await tasksRobot.enterTitle(task.title);
    await tasksRobot.enterDescription(task.description);
    await tasksRobot.tapCreateTaskButton();
    await goBack();
  }

  Future<void> navigateToCreateTasksScreen() async {
    await openPopupMenu();
    await tasksRobot.openTasksScreen();
    await tasksRobot.tapAddButton();
  }

  // navigation
  Future<void> closePage() async {
    final finder = find.byTooltip('Close');
    expect(finder, findsOneWidget);
    await widgetTester.tap(finder);
    await widgetTester.pumpAndSettle();
  }

  Future<void> goBack() async {
    final finder = find.byTooltip('Back');
    expect(finder, findsOneWidget);
    await widgetTester.tap(finder);
    await widgetTester.pumpAndSettle();
  }
}
