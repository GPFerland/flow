import 'package:flow/src/constants/breakpoints.dart';
import 'package:flow/src/features/check_list/presentation/app_bar/check_list_app_bar_title.dart';
import 'package:flow/src/features/check_list/presentation/app_bar/check_list_app_bar.dart';
import 'package:flow/src/features/check_list/presentation/check_list/components/toggle_visibility_button.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../robot.dart';
import '../../../utils.dart';

void main() {
  group('CheckListScreen', () {
    group('startup', () {
      testWidgets('no tasks, date is today', (widgetTester) async {
        final r = Robot(widgetTester);
        await r.pumpFlowApp();
        String expectedTitleDate = getFormattedDateString(getDateNoTimeToday());
        r.checkListRobot.expectFindXCheckListCards(0);
        r.checkListRobot.expectTitleDate(expectedTitleDate);
      });
    });

    group('swiping', () {
      testWidgets(
        'swipe left, no tasks, date is tomorrow',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.checkListRobot.swipeDateCheckListXTimes(
            1,
            SwipeDirection.left,
          );
          r.checkListRobot.expectFindXCheckListCards(0);
          r.checkListRobot.expectTitleDate(
            getFormattedDateString(getDateNoTimeTomorrow()),
          );
        },
      );

      testWidgets(
        'swipe right, no tasks, date is yesterday',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.checkListRobot.swipeDateCheckListXTimes(
            1,
            SwipeDirection.right,
          );
          r.checkListRobot.expectFindXCheckListCards(0);
          r.checkListRobot.expectTitleDate(
            getFormattedDateString(getDateNoTimeYesterday()),
          );
        },
      );

      testWidgets(
        'swipe left x3, no tasks, date is three days after today',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.checkListRobot.swipeDateCheckListXTimes(
            3,
            SwipeDirection.left,
          );
          r.checkListRobot.expectFindXCheckListCards(0);
          r.checkListRobot.expectTitleDate(
            getFormattedDateString(
              getDateNoTimeToday().add(const Duration(days: 3)),
            ),
          );
        },
      );

      testWidgets(
        'swipe right x3, no tasks, date is three days before today',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.checkListRobot.swipeDateCheckListXTimes(
            3,
            SwipeDirection.right,
          );
          r.checkListRobot.expectFindXCheckListCards(0);
          r.checkListRobot.expectTitleDate(
            getFormattedDateString(
              getDateNoTimeToday().subtract(const Duration(days: 3)),
            ),
          );
        },
      );
    });

    group('select date', () {
      testWidgets(
        'tap date title, select the a different date, date is selected date',
        (widgetTester) async {
          final r = Robot(widgetTester);
          int dateToSelect = 11;
          DateTime today = getDateNoTimeToday();
          String expectedTitle = getFormattedDateString(
            DateTime(today.year, today.month + 1, dateToSelect),
          );
          await r.pumpFlowApp();
          await r.tapType(CheckListAppBarTitle);
          await r.tapIcon(Icons.chevron_right);
          await r.tapText(dateToSelect.toString());
          await r.tapText('OK');
          r.checkListRobot.expectTitleDate(expectedTitle);
        },
      );
    });

    group('task instances', () {
      testWidgets(
        'add a daily task, verify displayed everyday after creation date, NEVER before',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task testTask = createTestTask().copyWith(
            frequency: Frequency.daily,
          );
          await r.goToTaskScreenFromCheckList();
          await r.tasksRobot.enterTitle(testTask.title);
          await r.tapKey(Frequency.daily.tabKey);
          await r.tapText('Create');
          r.tasksRobot.expectFindTaskListCard(testTask);
          await r.goBack();
          r.checkListRobot.expectFindXCheckListCards(1);
          await r.checkListRobot.swipeDateCheckListXTimes(
            2,
            SwipeDirection.left,
          );
          r.checkListRobot.expectTitleDate(
            getFormattedDateString(
              getDateNoTimeToday().add(const Duration(days: 2)),
            ),
          );
          r.checkListRobot.expectFindXCheckListCards(1);
          await r.checkListRobot.swipeDateCheckListXTimes(
            3,
            SwipeDirection.right,
          );
          r.checkListRobot.expectFindXCheckListCards(0);
        },
      );
    });

    group('complete', () {
      testWidgets(
        'add once task, complete task, tap hide completed, task hidden',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask();
          await r.createTaskFromCheckList(task);
          r.checkListRobot.expectFindXCheckListCards(1);
          await r.tapType(Checkbox);
          await r.tapKey(ToggleVisibilityButton.toggleVisibilityKey);
          r.checkListRobot.expectFindXCheckListCards(0);
        },
      );
      testWidgets(
        'add once task, tap hide completed, complete task, task hidden',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask();
          await r.createTaskFromCheckList(task);
          r.checkListRobot.expectFindXCheckListCards(1);
          await r.tapKey(ToggleVisibilityButton.toggleVisibilityKey);
          await r.tapType(Checkbox);
          r.checkListRobot.expectFindXCheckListCards(0);
        },
      );
      testWidgets(
        'add two once tasks, complete first task, tap hide completed, task hidden',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task1 = createTestTask();
          await r.createTaskFromCheckList(task1);
          final Task task2 = createTestTask(id: '2').copyWith(title: 'Poop');
          await r.createTaskFromCheckList(task2);
          r.checkListRobot.expectFindXCheckListCards(2);
          await r.tapType(Checkbox);
          await r.tapKey(ToggleVisibilityButton.toggleVisibilityKey);
          r.checkListRobot.expectFindXCheckListCards(1);
        },
      );
    });

    group('reschedule', () {
      testWidgets(
        'add a once task, verify reschedule',
        (widgetTester) async {
          // setup
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask();
          r.checkListRobot.expectFindXCheckListCards(0);
          await r.createTaskFromCheckList(task);
          r.checkListRobot.expectFindXCheckListCards(1);

          String dateToSelect = '11';

          // run
          await r.tapText(task.title);
          await r.tapText('Reschedule');
          await r.tapIcon(Icons.chevron_right);
          await r.tapText(dateToSelect);
          await r.tapText('OK');

          // verify
          await r.tapType(CheckListAppBarTitle);
          await r.tapIcon(Icons.chevron_right);
          await r.tapText(dateToSelect);
          await r.tapText('OK');
          r.checkListRobot.expectFindXCheckListCards(1);
        },
      );
    });

    group('skip', () {
      testWidgets(
        'add daily task, skip task, tap hide completed, task hidden',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask(frequency: Frequency.daily);
          await r.createTaskFromCheckList(task);
          r.checkListRobot.expectFindXCheckListCards(1);
          await r.skipTask(task.title);
          await r.tapKey(ToggleVisibilityButton.toggleVisibilityKey);
          r.checkListRobot.expectFindXCheckListCards(0);
        },
      );
      testWidgets(
        'add daily task, tap hide completed, skip task, task hidden',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask(frequency: Frequency.daily);
          await r.createTaskFromCheckList(task);
          r.checkListRobot.expectFindXCheckListCards(1);
          await r.tapKey(ToggleVisibilityButton.toggleVisibilityKey);
          await r.skipTask(task.title);
          r.checkListRobot.expectFindXCheckListCards(0);
        },
      );
    });

    group('edit', () {
      testWidgets(
        'add a once task, on long press open edit task screen',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask();
          await r.createTaskFromCheckList(task);
          r.checkListRobot.expectFindXCheckListCards(1);
          await r.longPressText(task.title);
          await r.closePage();
        },
      );
    });

    group('app bar menu', () {
      testWidgets(
        'screen size is less than the tablet breakpoint, null user',
        (widgetTester) async {
          TestWidgetsFlutterBinding.ensureInitialized();
          widgetTester.view.physicalSize = const Size(
            Breakpoint.tablet - 1,
            640,
          );
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.checkListRobot.openPopupMenu();
          await r.tapKey(CheckListAppBar.tasksMenuButtonKey);
          await r.goBack();
          await r.checkListRobot.openPopupMenu();
          await r.tapKey(CheckListAppBar.signInMenuButtonKey);
          await r.closePage();
        },
      );

      testWidgets(
        'screen size is less than the tablet breakpoint, user signed in',
        (widgetTester) async {
          TestWidgetsFlutterBinding.ensureInitialized();
          widgetTester.view.physicalSize = const Size(
            Breakpoint.tablet - 1,
            640,
          );
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.signInFromCheckList();
          r.checkListRobot.expectTitleDate('Today');
          await r.checkListRobot.openPopupMenu();
          await r.tapKey(CheckListAppBar.tasksMenuButtonKey);
          await r.goBack();
          await r.checkListRobot.openPopupMenu();
          await r.tapKey(CheckListAppBar.accountMenuButtonKey);
          await r.closePage();
        },
      );

      testWidgets(
        'screen size is greater than the tablet breakpoint, null user',
        (widgetTester) async {
          TestWidgetsFlutterBinding.ensureInitialized();
          widgetTester.view.physicalSize = const Size(
            Breakpoint.tablet + 1,
            640,
          );
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.checkListRobot.openPopupMenu();
          await r.tapKey(CheckListAppBar.tasksMenuButtonKey);
          await r.goBack();
          await r.checkListRobot.openPopupMenu();
          await r.tapKey(CheckListAppBar.signInMenuButtonKey);
          await r.closePage();
        },
      );

      testWidgets(
        'screen size is greater than the tablet breakpoint, user signed in',
        (widgetTester) async {
          TestWidgetsFlutterBinding.ensureInitialized();
          widgetTester.view.physicalSize = const Size(
            Breakpoint.tablet + 1,
            640,
          );
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.signInFromCheckList();
          await r.checkListRobot.openPopupMenu();
          await r.tapKey(CheckListAppBar.tasksMenuButtonKey);
          await r.goBack();
          await r.checkListRobot.openPopupMenu();
          await r.tapKey(CheckListAppBar.accountMenuButtonKey);
          await r.closePage();
        },
      );
    });
  });
}
