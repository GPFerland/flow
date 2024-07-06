import 'package:flow/src/common_widgets/buttons/primary_button.dart';
import 'package:flow/src/features/date_check_list/presentation/date_app_bar/date_title.dart';
import 'package:flow/src/features/tasks/presentation/task_form/task_frequency_fields/monthly_task_fields.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';
import '../../../../utils.dart';

void main() {
  group('CreateTaskScreen - invalid input', () {
    testWidgets('''
        Given CreateTaskScreen is opened
        If the title field is empty
        And the Submit button is pressed
        Then a title validation error is shown
        ''', (widgetTester) async {
      final r = Robot(widgetTester);
      await r.pumpFlowApp();
      await r.goToCreateTaskFromDateCheckList();
      await r.tapType(PrimaryButton);
      r.tasksRobot.expectTitleValidationErrorFound();
    });
  });

  group('CreateTaskScreen - once type task', () {
    testWidgets('''
        Given CreateTaskScreen is opened
        And the fields are valid
        And the task type selected is Once
        And the Create Task button is pressed
        Then a task shows up on the tasks screen
        And on the proper date in the date check list screen
        ''', (widgetTester) async {
      final r = Robot(widgetTester);
      final testTask = createTestTask();
      await r.pumpFlowApp();
      await r.goToCreateTaskFromDateCheckList();
      await r.tasksRobot.enterTitle(testTask.title);
      await r.tasksRobot.enterDescription(testTask.description);
      await r.tapType(PrimaryButton);
      r.tasksRobot.expectFindTaskListCard(testTask);
      await r.goBack();
      r.dateCheckListRobot.expectTitleDate('Today');
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
      await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
      await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(3);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
    });
    testWidgets('''
        Given CreateTaskScreen is opened
        And the fields are valid
        And the task type selected is Once
        And the user selects a new date
        And the Submit button is pressed
        Then a task shows up on the tasks screen
        And on the proper date in the date check list screen
        ''', (widgetTester) async {
      final r = Robot(widgetTester);
      final testTask = createTestTask();
      await r.pumpFlowApp();
      await r.goToCreateTaskFromDateCheckList();
      await r.tasksRobot.enterTitle(testTask.title);
      await r.tasksRobot.enterDescription(testTask.description);

      String dateToSelect = '11';
      String expectedTitle = getTitleDateString(
        getDateNoTimeToday().copyWith(day: 11),
      );
      if (getDateNoTimeToday().day == 11) {
        dateToSelect = '22';
        expectedTitle = getTitleDateString(
          getDateNoTimeToday().copyWith(day: 22),
        );
      }

      await r.tapText('Select Date');
      await r.tapText(dateToSelect);
      await r.tapText('OK');

      await r.tapType(PrimaryButton);
      r.tasksRobot.expectFindTaskListCard(testTask);
      await r.goBack();
      r.dateCheckListRobot.expectTitleDate('Today');
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);

      await r.tapType(DateTitle);
      await r.tapText(dateToSelect);
      await r.tapText('OK');
      r.dateCheckListRobot.expectTitleDate(expectedTitle);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
    });
  });

  group('CreateTaskScreen - daily type task', () {
    testWidgets('''
        Given CreateTaskScreen is opened
        And the fields are valid
        And the task type selected is Daily
        And the Submit button is pressed
        Then a task shows up on the tasks screen
        And on every date in the date check list screen
        ''', (widgetTester) async {
      final r = Robot(widgetTester);
      final testTask = createTestTask();
      await r.pumpFlowApp();
      await r.goToCreateTaskFromDateCheckList();
      await r.tasksRobot.enterTitle(testTask.title);
      await r.tasksRobot.enterDescription(testTask.description);

      await r.tapKey(FrequencyType.daily.tabKey);
      await r.tapText('Everyday');

      await r.tapType(PrimaryButton);
      r.tasksRobot.expectFindTaskListCard(testTask);
      await r.goBack();
      r.dateCheckListRobot.expectTitleDate('Today');
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectTitleDate('Yesterday');
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(3);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
    });
  });

  group('CreateTaskScreen - weekly type task', () {
    testWidgets('''
        Given CreateTaskScreen is opened
        And the fields are valid
        And the task type selected is Weekly
        And all of the days of the week are selected by pressing the All button
        And the Submit button is pressed
        Then a task shows up on the tasks screen
        And on every date in the date check list screen
        ''', (widgetTester) async {
      final r = Robot(widgetTester);
      final testTask = createTestTask();
      await r.pumpFlowApp();
      await r.goToCreateTaskFromDateCheckList();
      await r.tasksRobot.enterTitle(testTask.title);
      await r.tasksRobot.enterDescription(testTask.description);

      await r.tapKey(FrequencyType.weekly.tabKey);
      await r.tapText('All');

      await r.tapType(PrimaryButton);
      r.tasksRobot.expectFindTaskListCard(testTask);
      await r.goBack();
      r.dateCheckListRobot.expectTitleDate('Today');
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectTitleDate('Yesterday');
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(3);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
    });
    testWidgets('''
        Given CreateTaskScreen is opened
        And the fields are valid
        And the task type selected is Weekly
        And all of the days of the week are selected by each days button
        And the Submit button is pressed
        Then a task shows up on the tasks screen
        And on every date in the date check list screen
        ''', (widgetTester) async {
      final r = Robot(widgetTester);
      final testTask = createTestTask();
      await r.pumpFlowApp();
      await r.goToCreateTaskFromDateCheckList();
      await r.tasksRobot.enterTitle(testTask.title);
      await r.tasksRobot.enterDescription(testTask.description);

      await r.tapKey(FrequencyType.weekly.tabKey);
      for (Weekday day in Weekday.values) {
        if (day.weekdayIndex == -1) {
          continue;
        }
        await r.tapText(day.shorthand);
      }

      await r.tapType(PrimaryButton);
      r.tasksRobot.expectFindTaskListCard(testTask);
      await r.goBack();
      r.dateCheckListRobot.expectTitleDate('Today');
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectTitleDate('Yesterday');
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(3);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
      await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(1);
      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
    });
  });

  group('CreateTaskScreen - monthly type task', () {
    testWidgets('''
        Given CreateTaskScreen is opened
        And the fields are valid
        And the task type selected is Monthly
        And the add button is pressed
        And the Submit button is pressed
        Then a task shows up on the tasks screen
        And on the first day of the month
        ''', (widgetTester) async {
      final r = Robot(widgetTester);
      final testTask = createTestTask();
      await r.pumpFlowApp();
      await r.goToCreateTaskFromDateCheckList();
      await r.tasksRobot.enterTitle(testTask.title);
      await r.tasksRobot.enterDescription(testTask.description);

      await r.tapKey(FrequencyType.monthly.tabKey);
      await r.tapKey(MonthlyTaskFields.plusIconButtonKey);

      await r.tapType(PrimaryButton);
      r.tasksRobot.expectFindTaskListCard(testTask);
      await r.goBack();
      r.dateCheckListRobot.expectTitleDate('Today');

      await r.tapType(DateTitle);
      await r.tapText('1');
      await r.tapText('OK');

      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
    });
    testWidgets('''
        Given CreateTaskScreen is opened
        And the fields are valid
        And the task type selected is Monthly
        And the ordinal dropdown is changed to Fourth
        And the Submit button is pressed
        Then a task shows up on the tasks screen
        And a task instance shows up on the 4th of the month 
        ''', (widgetTester) async {
      final r = Robot(widgetTester);
      final testTask = createTestTask();
      await r.pumpFlowApp();
      await r.goToCreateTaskFromDateCheckList();
      await r.tasksRobot.enterTitle(testTask.title);
      await r.tasksRobot.enterDescription(testTask.description);

      await r.tapKey(FrequencyType.monthly.tabKey);

      await r.tapKey(MonthlyTaskFields.ordinalDropdownKey);
      await r.tapText(Ordinal.fourth.longhand);

      await r.tapKey(MonthlyTaskFields.plusIconButtonKey);

      await r.tapType(PrimaryButton);
      r.tasksRobot.expectFindTaskListCard(testTask);
      await r.goBack();
      r.dateCheckListRobot.expectTitleDate('Today');

      await r.tapType(DateTitle);
      await r.tapText('4');
      await r.tapText('OK');

      r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
    });
  });
}
