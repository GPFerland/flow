import 'package:flow/src/constants/test_tasks.dart';
import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/date_check_list/presentation/check_list_screen/check_list_app_bar/more_menu_button.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/local/test_local_tasks_repository.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list_screen/task_list_card/task_list_card.dart';
import 'package:flow/src/flow_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/authentication/auth_robot.dart';
import 'features/tasks/tasks_robot.dart';

class Robot {
  Robot(this.widgetTester)
      : authRobot = AuthRobot(widgetTester),
        tasksRobot = TasksRobot(widgetTester);
  final WidgetTester widgetTester;
  final AuthRobot authRobot;
  final TasksRobot tasksRobot;

  Future<void> pumpFlowApp() async {
    // Override repositories
    final tasksRepository = TestLocalTasksRepository();
    final authRepository = TestAuthRepository(addDelay: false);
    await widgetTester.pumpWidget(
      ProviderScope(
        overrides: [
          localTasksRepositoryProvider.overrideWithValue(tasksRepository),
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: const FlowApp(),
      ),
    );
    await widgetTester.pumpAndSettle();
  }

  void expectFindAllProductCards() {
    final finder = find.byType(TaskListCard);
    expect(finder, findsNWidgets(kTestTasks.tasksList.length));
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
}
