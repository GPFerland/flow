import 'package:flow/src/features/tasks/presentation/edit_task_screen/delete_task_button.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';
import '../../../../utils.dart';

void main() {
  group('EditTaskScreen - delete', () {
    testWidgets(
      '''
        Given EditTaskScreen is opened
        If the delete icon button is pressed
        And the delete dialog button is pressed to confirm
        Then the task will be deleted
        ''',
      (widgetTester) async {
        final task = createTestTask();
        final r = Robot(widgetTester);
        await r.pumpFlowApp();
        await r.createTaskFromDateCheckList(task);
        r.dateCheckListRobot.expectTitleDate('Today');
        r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
        await r.longPressText(task.title);
        await r.tapKey(DeleteTaskButton.deleteTaskIconButtonKey);
        await r.tapKey(DeleteTaskButton.deleteTaskDialogButtonKey);
        r.dateCheckListRobot.expectTitleDate('Today');
        r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
      },
    );
    testWidgets(
      '''
        Given EditTaskScreen is opened
        If the delete icon button is pressed
        And the cancel dialog button is pressed
        Then the edit task screen is closed
        Then the task will NOT be deleted
        ''',
      (widgetTester) async {
        final task = createTestTask();
        final r = Robot(widgetTester);
        await r.pumpFlowApp();
        await r.createTaskFromDateCheckList(task);
        r.dateCheckListRobot.expectTitleDate('Today');
        r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
        await r.longPressText(task.title);
        await r.tapKey(DeleteTaskButton.deleteTaskIconButtonKey);
        await r.tapKey(DeleteTaskButton.cancelDialogButtonKey);
        await r.closePage();
        r.dateCheckListRobot.expectTitleDate('Today');
        r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      },
    );
  });
}
