import 'package:flow/src/features/check_list/presentation/app_bar/check_list_app_bar.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';
import '../../../../utils.dart';

void main() {
  group('TaskListScreen', () {
    testWidgets(
      '''
        Given TaskListScreen is opened
        And the user taps a task to open the edit task screen
        And then press the go back button
        Then the user is returned to the task list screen
        ''',
      (widgetTester) async {
        final task = createTestTask();
        final r = Robot(widgetTester);
        await r.pumpFlowApp();
        await r.createTaskFromCheckList(task);
        await r.dateCheckListRobot.openPopupMenu();
        await r.tapKey(CheckListAppBar.tasksMenuButtonKey);
        await r.tapText(task.title);
        await r.closePage();
      },
    );
  });
}
