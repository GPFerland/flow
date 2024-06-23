import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';

void main() {
  group(
    'CreateTaskScreen - invalid input',
    () {
      testWidgets(
        '''
        Given CreateTaskScreen is opened
        If the title field is empty
        And the Create Task button is pressed
        Then a title validation error is shown
        ''',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.navigateToCreateTasksScreen();
          await r.tasksRobot.tapCreateTaskButton();
          r.tasksRobot.expectTitleValidationErrorFound();
        },
      );
    },
  );
}
