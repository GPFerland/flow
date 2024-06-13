import 'package:flow/src/constants/test_tasks.dart';
import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/check_list/presentation/check_list_app_bar/more_menu_button.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/local/test_local_tasks_repository.dart';
import 'package:flow/src/features/tasks/presentation/task_list_card/task_list_card.dart';
import 'package:flow/src/flow_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/authentication/auth_robot.dart';
//import 'goldens/golden_robot.dart';

class Robot {
  Robot(this.tester) : auth = AuthRobot(tester);
  //golden = GoldenRobot(tester);
  final WidgetTester tester;
  final AuthRobot auth;
  //final GoldenRobot golden;

  Future<void> pumpMyApp() async {
    // Override repositories
    final tasksRepository = TestLocalTasksRepository(addDelay: false);
    final authRepository = TestAuthRepository(addDelay: false);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localTasksRepositoryProvider.overrideWithValue(tasksRepository),
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: const FlowApp(),
      ),
    );
    await tester.pumpAndSettle();
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
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
    // else no-op, as the items are already visible
  }
}
