import 'package:flow/src/constants/breakpoints.dart';
import 'package:flow/src/features/check_list/presentation/app_bar/check_list_app_bar_title.dart';
import 'package:flow/src/features/check_list/presentation/app_bar/check_list_app_bar.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../robot.dart';
import '../../../utils.dart';

void main() {
  group(
    'CheckListScreen - startup',
    () {
      testWidgets(
        'no tasks, date is today',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          String expectedTitleDate = getTitleDateString(getDateNoTimeToday());
          r.dateCheckListRobot.expectFindXCheckListCards(0);
          r.dateCheckListRobot.expectTitleDate(expectedTitleDate);
        },
      );
    },
  );

  group(
    'CheckListScreen - swiping',
    () {
      testWidgets(
        'swipe left, no tasks, date is tomorrow',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.dateCheckListRobot.swipeDateCheckListXTimes(
            1,
            SwipeDirection.left,
          );
          r.dateCheckListRobot.expectFindXCheckListCards(0);
          r.dateCheckListRobot.expectTitleDate(
            getTitleDateString(getDateNoTimeTomorrow()),
          );
        },
      );

      testWidgets(
        'swipe right, no tasks, date is yesterday',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.dateCheckListRobot.swipeDateCheckListXTimes(
            1,
            SwipeDirection.right,
          );
          r.dateCheckListRobot.expectFindXCheckListCards(0);
          r.dateCheckListRobot.expectTitleDate(
            getTitleDateString(getDateNoTimeYesterday()),
          );
        },
      );

      testWidgets(
        'swipe left x3, no tasks, date is three days after today',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.dateCheckListRobot.swipeDateCheckListXTimes(
            3,
            SwipeDirection.left,
          );
          r.dateCheckListRobot.expectFindXCheckListCards(0);
          r.dateCheckListRobot.expectTitleDate(
            getTitleDateString(
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
          await r.dateCheckListRobot.swipeDateCheckListXTimes(
            3,
            SwipeDirection.right,
          );
          r.dateCheckListRobot.expectFindXCheckListCards(0);
          r.dateCheckListRobot.expectTitleDate(
            getTitleDateString(
              getDateNoTimeToday().subtract(const Duration(days: 3)),
            ),
          );
        },
      );
    },
  );

  group(
    'CheckListScreen - select date',
    () {
      testWidgets(
        'tap date title, select the a different date, date is selected date',
        (widgetTester) async {
          final r = Robot(widgetTester);
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
          await r.pumpFlowApp();
          await r.tapType(CheckListAppBarTitle);
          await r.tapText(dateToSelect);
          await r.tapText('OK');
          r.dateCheckListRobot.expectTitleDate(expectedTitle);
        },
      );
    },
  );

  group(
    'CheckListScreen - task instances',
    () {
      testWidgets(
        'add a daily task, verify task instance displayed everyday',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task testTask =
              createTestTask().copyWith(frequency: Frequency.daily);
          await r.goToTaskScreenFromCheckList();
          await r.tasksRobot.enterTitle(testTask.title);
          await r.tapKey(Frequency.daily.tabKey);
          await r.tapText('Create');
          r.tasksRobot.expectFindTaskListCard(testTask);
          await r.goBack();
          r.dateCheckListRobot.expectFindXCheckListCards(1);
          await r.dateCheckListRobot.swipeDateCheckListXTimes(
            2,
            SwipeDirection.left,
          );
          r.dateCheckListRobot.expectTitleDate(
            getTitleDateString(
              getDateNoTimeToday().add(const Duration(days: 2)),
            ),
          );
          r.dateCheckListRobot.expectFindXCheckListCards(1);
          await r.dateCheckListRobot.swipeDateCheckListXTimes(
            8,
            SwipeDirection.right,
          );
          r.dateCheckListRobot.expectFindXCheckListCards(1);
        },
      );
    },
  );

  group(
    'CheckListScreen - complete',
    () {
      testWidgets(
        'add a once task, complete the task',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask();
          await r.createTaskFromCheckList(task);
          r.dateCheckListRobot.expectFindXCheckListCards(1);
          await r.tapType(Checkbox);
        },
      );
    },
  );

  group(
    'CheckListScreen - reschedule',
    () {
      testWidgets(
        'add a once task, verify reschedule',
        (widgetTester) async {
          // setup
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask();
          r.dateCheckListRobot.expectFindXCheckListCards(0);
          await r.createTaskFromCheckList(task);
          r.dateCheckListRobot.expectFindXCheckListCards(1);
          int dateToSelect = 11;
          int todaysDate = getDateNoTimeToday().day;
          if (todaysDate == dateToSelect) {
            dateToSelect = 22;
          }
          // run
          await r.rescheduleTask(
            task.title,
            dateToSelect.toString(),
          );
          // verify
          r.dateCheckListRobot.expectFindXCheckListCards(0);
          if (dateToSelect < todaysDate) {
            await r.dateCheckListRobot.swipeDateCheckListXTimes(
              todaysDate - dateToSelect,
              SwipeDirection.right,
            );
          } else {
            await r.dateCheckListRobot.swipeDateCheckListXTimes(
              dateToSelect - todaysDate,
              SwipeDirection.left,
            );
          }
          r.dateCheckListRobot.expectFindXCheckListCards(1);
        },
      );
    },
  );

  group(
    'CheckListScreen - skip',
    () {
      testWidgets(
        'add a once task, skip the task',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask();
          await r.createTaskFromCheckList(task);
          r.dateCheckListRobot.expectFindXCheckListCards(1);
          await r.skipTask(task.title);
        },
      );
    },
  );

  group(
    'CheckListScreen - edit',
    () {
      testWidgets(
        'add a once task, on long press open edit task screen',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask();
          await r.createTaskFromCheckList(task);
          r.dateCheckListRobot.expectFindXCheckListCards(1);
          await r.longPressText(task.title);
          await r.closePage();
        },
      );
    },
  );

  group(
    'CheckListScreen - app bar menu',
    () {
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
          await r.dateCheckListRobot.openPopupMenu();
          await r.tapKey(CheckListAppBar.tasksMenuButtonKey);
          await r.goBack();
          await r.dateCheckListRobot.openPopupMenu();
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
          await r.signInFromDateCheckList();
          r.dateCheckListRobot.expectTitleDate('Today');
          await r.dateCheckListRobot.openPopupMenu();
          await r.tapKey(CheckListAppBar.tasksMenuButtonKey);
          await r.goBack();
          await r.dateCheckListRobot.openPopupMenu();
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
          await r.dateCheckListRobot.openPopupMenu();
          await r.tapKey(CheckListAppBar.tasksMenuButtonKey);
          await r.goBack();
          await r.dateCheckListRobot.openPopupMenu();
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
          await r.signInFromDateCheckList();
          await r.dateCheckListRobot.openPopupMenu();
          await r.tapKey(CheckListAppBar.tasksMenuButtonKey);
          await r.goBack();
          await r.dateCheckListRobot.openPopupMenu();
          await r.tapKey(CheckListAppBar.accountMenuButtonKey);
          await r.closePage();
        },
      );
    },
  );
}
