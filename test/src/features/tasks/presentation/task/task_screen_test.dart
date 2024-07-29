import 'package:flow/src/common_widgets/buttons/primary_button.dart';
import 'package:flow/src/features/check_list/presentation/app_bar/check_list_app_bar_title.dart';
import 'package:flow/src/features/tasks/presentation/task/app_bar/task_app_bar_actions/delete_task_button.dart';
import 'package:flow/src/features/tasks/presentation/task/form/components/frequency/components/monthly_fields.dart';
import 'package:flow/src/features/tasks/presentation/task/form/components/task_color_input_field.dart';
import 'package:flow/src/features/tasks/presentation/task/form/components/task_icon_input_field.dart';
import 'package:flow/src/features/tasks/presentation/task/form/components/task_until_complete_switch.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';
import '../../../../utils.dart';

void main() {
  group('task is null', () {
    group('invalid input', () {
      testWidgets('''
        Given the task argument is null
        If the title field is empty
        And the create button is pressed
        Then a title validation error is shown
        ''', (widgetTester) async {
        final r = Robot(widgetTester);
        await r.pumpFlowApp();
        await r.goToTaskScreenFromCheckList();
        await r.tapType(PrimaryButton);
        r.tasksRobot.expectTitleValidationErrorFound();
      });
    });

    group('once frequency', () {
      testWidgets(
        '''
        Given the task argument is null
        And the fields are valid
        And the frequency selected is Once
        And the create button is pressed
        Then a task shows up on the tasks screen
        And on the proper date in the check list screen
        ''',
        (widgetTester) async {
          final r = Robot(widgetTester);
          final testTask = createTestTask();
          await r.pumpFlowApp();
          await r.goToTaskScreenFromCheckList();
          await r.tasksRobot.enterTitle(testTask.title);
          await r.tasksRobot.enterDescription(testTask.description);
          await r.tapKey(TaskIconInputField.taskIconKey);
          await r.tapText('Close');
          await r.tapKey(TaskColorInputField.taskColorKey);
          await r.tapKey(TaskColorInputField.taskColorConfirmKey);
          await r.tapKey(Frequency.once.tabKey);
          await r.tapText('Create');
          r.tasksRobot.expectFindTaskListCard(testTask);
          await r.goBack();
          r.checkListRobot.expectTitleDate('Today');
          r.checkListRobot.expectFindXCheckListCards(1);
          await r.checkListRobot.swipeDateCheckListXTimes(
            1,
            SwipeDirection.right,
          );
          await r.widgetTester.pumpAndSettle();
          r.checkListRobot.expectTitleDate('Yesterday');
          r.checkListRobot.expectFindXCheckListCards(0);
          await r.checkListRobot.swipeDateCheckListXTimes(
            1,
            SwipeDirection.right,
          );
          r.checkListRobot.expectFindXCheckListCards(0);
          await r.checkListRobot.swipeDateCheckListXTimes(
            1,
            SwipeDirection.right,
          );
          r.checkListRobot.expectFindXCheckListCards(0);
          await r.checkListRobot.swipeDateCheckListXTimes(
            3,
            SwipeDirection.left,
          );
          r.checkListRobot.expectFindXCheckListCards(1);
          await r.checkListRobot.swipeDateCheckListXTimes(
            1,
            SwipeDirection.left,
          );
          r.checkListRobot.expectFindXCheckListCards(0);
          await r.checkListRobot.swipeDateCheckListXTimes(
            1,
            SwipeDirection.left,
          );
          r.checkListRobot.expectFindXCheckListCards(0);
          await r.checkListRobot.swipeDateCheckListXTimes(
            1,
            SwipeDirection.left,
          );
          r.checkListRobot.expectFindXCheckListCards(0);
        },
      );
      testWidgets('''
        Given the task argument is null
        And the fields are valid
        And the frequency selected is Once
        And the user selects a new date
        And the create button is pressed
        Then a task shows up on the tasks screen
        And on the proper date in the check list screen
        ''', (widgetTester) async {
        final r = Robot(widgetTester);
        final testTask = createTestTask();
        await r.pumpFlowApp();
        await r.goToTaskScreenFromCheckList();
        await r.tasksRobot.enterTitle(testTask.title);
        await r.tasksRobot.enterDescription(testTask.description);
        await r.tapKey(TaskUntilCompletedSwitch.untilCompletedKey);
        await r.tapKey(Frequency.once.tabKey);

        String dateToSelect = '11';

        await r.tapText('Select Date');
        await r.tapIcon(Icons.chevron_right);
        await r.tapText(dateToSelect);
        await r.tapText('OK');

        await r.tapText('Create');
        r.tasksRobot.expectFindTaskListCard(testTask);
        await r.goBack();
        r.checkListRobot.expectTitleDate('Today');
        r.checkListRobot.expectFindXCheckListCards(0);

        await r.tapType(CheckListAppBarTitle);
        await r.tapIcon(Icons.chevron_right);
        await r.tapText(dateToSelect);
        await r.tapText('OK');
        r.checkListRobot.expectFindXCheckListCards(1);
      });
    });

    group('daily frequency', () {
      testWidgets('''
        Given the task argument is null
        And the fields are valid
        And the frequency selected is Daily
        And the create button is pressed
        Then a task shows up on the tasks screen
        And on every date in the date check list screen
        ''', (widgetTester) async {
        final r = Robot(widgetTester);
        final testTask = createTestTask();
        await r.pumpFlowApp();
        await r.goToTaskScreenFromCheckList();
        await r.tasksRobot.enterTitle(testTask.title);
        await r.tasksRobot.enterDescription(testTask.description);
        await r.tapKey(Frequency.daily.tabKey);
        await r.tapText('Everyday');
        await r.tapType(PrimaryButton);
        r.tasksRobot.expectFindTaskListCard(testTask);
        await r.goBack();
        r.checkListRobot.expectFindXCheckListCards(1);
        await r.checkListRobot.swipeDateCheckListXTimes(
          1,
          SwipeDirection.right,
        );
        r.checkListRobot.expectFindXCheckListCards(0);
        for (int i = 1; i < 20; i++) {
          await r.checkListRobot.swipeDateCheckListXTimes(
            i,
            SwipeDirection.left,
          );
          r.checkListRobot.expectFindXCheckListCards(1);
        }
      });
    });

    group('weekly frequency', () {
      testWidgets('''
        Given the task argument is null
        And the fields are valid
        And the frequency selected is Weekly
        And all of the days of the week are selected by pressing the All button
        And the create button is pressed
        Then a task shows up on the tasks screen
        And on every date in the date check list screen
        ''', (widgetTester) async {
        final r = Robot(widgetTester);
        final testTask = createTestTask();
        await r.pumpFlowApp();
        await r.goToTaskScreenFromCheckList();
        await r.tasksRobot.enterTitle(testTask.title);
        await r.tasksRobot.enterDescription(testTask.description);
        await r.tapKey(Frequency.weekly.tabKey);
        await r.tapText('All');
        await r.tapText('Clear');
        await r.tapText('All');
        await r.tapType(PrimaryButton);
        r.tasksRobot.expectFindTaskListCard(testTask);
        await r.goBack();
        r.checkListRobot.expectTitleDate('Today');
        r.checkListRobot.expectFindXCheckListCards(1);
        await r.checkListRobot.swipeDateCheckListXTimes(
          1,
          SwipeDirection.right,
        );
        r.checkListRobot.expectFindXCheckListCards(0);
        for (int i = 1; i < 20; i++) {
          await r.checkListRobot.swipeDateCheckListXTimes(
            i,
            SwipeDirection.left,
          );
          r.checkListRobot.expectFindXCheckListCards(1);
        }
      });
      testWidgets('''
        Given the task argument is null
        And the fields are valid
        And the frequency selected is Weekly
        And all of the days of the week are selected by each days button
        And the create button is pressed
        Then a task shows up on the tasks screen
        And on every date in the date check list screen
        ''', (widgetTester) async {
        final r = Robot(widgetTester);
        final testTask = createTestTask();
        await r.pumpFlowApp();
        await r.goToTaskScreenFromCheckList();
        await r.tasksRobot.enterTitle(testTask.title);
        await r.tasksRobot.enterDescription(testTask.description);

        await r.tapKey(Frequency.weekly.tabKey);
        for (Weekday day in Weekday.values) {
          if (day.weekdayIndex == -1) {
            continue;
          }
          await r.tapText(day.shorthand);
        }

        await r.tapText(Weekday.sun.shorthand);
        await r.tapText(Weekday.sun.shorthand);

        await r.tapType(PrimaryButton);
        r.tasksRobot.expectFindTaskListCard(testTask);
        await r.goBack();
        r.checkListRobot.expectTitleDate('Today');
        r.checkListRobot.expectFindXCheckListCards(1);
        await r.checkListRobot.swipeDateCheckListXTimes(
          1,
          SwipeDirection.right,
        );
        r.checkListRobot.expectFindXCheckListCards(0);
        for (int i = 1; i < 20; i++) {
          await r.checkListRobot.swipeDateCheckListXTimes(
            i,
            SwipeDirection.left,
          );
          r.checkListRobot.expectFindXCheckListCards(1);
        }
      });
    });

    group('monthly frequency', () {
      testWidgets('''
        Given the task argument is null
        And the fields are valid
        And the frequency selected is Monthly
        And the add button is pressed
        And the create button is pressed
        Then a task shows up on the tasks screen
        And on the first day of the next month
        ''', (widgetTester) async {
        final r = Robot(widgetTester);
        final testTask = createTestTask();
        await r.pumpFlowApp();
        await r.goToTaskScreenFromCheckList();
        await r.tasksRobot.enterTitle(testTask.title);
        await r.tasksRobot.enterDescription(testTask.description);

        await r.tapKey(Frequency.monthly.tabKey);
        await r.tapKey(MonthlyFields.plusIconButtonKey);
        await r.tapKey(MonthlyFields.clearIconButtonKey);
        await r.tapKey(MonthlyFields.weekdayDropdownKey);
        await r.tapText(Weekday.sun.longhand);
        await r.tapKey(MonthlyFields.ordinalDropdownKey);
        await r.tapText(Ordinal.last.longhand);
        await r.tapKey(MonthlyFields.plusIconButtonKey);

        await r.tapType(PrimaryButton);
        r.tasksRobot.expectFindTaskListCard(testTask);
        await r.goBack();
        r.checkListRobot.expectTitleDate('Today');

        final today = getDateNoTimeToday();
        final lastDayNextMonth = DateTime(today.year, today.month + 2, 0);
        final lastSunday = subtractTillWeekday(
          date: lastDayNextMonth,
          weekdayIndex: Weekday.sun.weekdayIndex,
        );

        await r.tapType(CheckListAppBarTitle);
        await r.tapIcon(Icons.chevron_right);
        await r.tapText(lastSunday.day.toString());
        await r.tapText('OK');

        r.checkListRobot.expectFindXCheckListCards(1);
      });
      testWidgets('''
        Given the task argument is null
        And the fields are valid
        And the frequency selected is Monthly
        And the ordinal dropdown is changed to Fourth
        And the add button is pressed
        And the create button is pressed
        Then a task shows up on the tasks screen
        And a task instance shows up on the 4th of the next month
        ''', (widgetTester) async {
        final r = Robot(widgetTester);
        final testTask = createTestTask();
        await r.pumpFlowApp();
        await r.goToTaskScreenFromCheckList();
        await r.tasksRobot.enterTitle(testTask.title);
        await r.tasksRobot.enterDescription(testTask.description);

        await r.tapKey(Frequency.monthly.tabKey);

        await r.tapKey(MonthlyFields.ordinalDropdownKey);
        await r.tapText(Ordinal.fourth.longhand);

        await r.tapKey(MonthlyFields.plusIconButtonKey);

        await r.tapType(PrimaryButton);
        r.tasksRobot.expectFindTaskListCard(testTask);
        await r.goBack();
        r.checkListRobot.expectTitleDate('Today');
        r.checkListRobot.expectFindXCheckListCards(0);

        await r.tapType(CheckListAppBarTitle);
        await r.tapIcon(Icons.chevron_right);
        await r.tapText('4');
        await r.tapText('OK');

        r.checkListRobot.expectFindXCheckListCards(1);
      });
    });
  });

  group('task is NOT null', () {
    group('delete', () {
      testWidgets(
        '''
        Given the task argument is NOT null
        If the delete icon button is pressed
        And the delete dialog button is pressed to confirm
        Then the task will be deleted
        ''',
        (widgetTester) async {
          final task = createTestTask();
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.createTaskFromCheckList(task);
          r.checkListRobot.expectTitleDate('Today');
          r.checkListRobot.expectFindXCheckListCards(1);
          await r.longPressText(task.title);
          await r.tapKey(DeleteTaskButton.deleteTaskIconButtonKey);
          await r.tapKey(DeleteTaskButton.deleteTaskDialogButtonKey);
          r.checkListRobot.expectTitleDate('Today');
          r.checkListRobot.expectFindXCheckListCards(0);
        },
      );
      testWidgets(
        '''
        Given the task argument is NOT null
        If the delete icon button is pressed
        And the cancel dialog button is pressed
        Then the task will NOT be deleted
        ''',
        (widgetTester) async {
          final task = createTestTask();
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.createTaskFromCheckList(task);
          r.checkListRobot.expectTitleDate('Today');
          r.checkListRobot.expectFindXCheckListCards(1);
          await r.longPressText(task.title);
          await r.tapKey(DeleteTaskButton.deleteTaskIconButtonKey);
          await r.tapKey(DeleteTaskButton.cancelDialogButtonKey);
          await r.closePage();
          r.checkListRobot.expectTitleDate('Today');
          r.checkListRobot.expectFindXCheckListCards(1);
        },
      );
    });
  });
}
