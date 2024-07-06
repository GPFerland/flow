import 'package:flow/src/features/date_check_list/presentation/date_app_bar/date_app_bar.dart';
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
        await r.createTaskFromDateCheckList(task);
        await r.dateCheckListRobot.openPopupMenu();
        await r.tapKey(DateAppBar.tasksMenuButtonKey);
        await r.tapText(task.title);
        await r.closePage();
      },
    );
  });
}
