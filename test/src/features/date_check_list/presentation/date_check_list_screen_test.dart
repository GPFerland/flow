import 'package:flow/src/constants/breakpoints.dart';
import 'package:flow/src/features/date_check_list/presentation/date_app_bar/date_app_bar.dart';
import 'package:flow/src/features/date_check_list/presentation/date_app_bar/date_title.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../robot.dart';
import '../../../utils.dart';

void main() {
  group(
    'DateCheckListScreen - startup',
    () {
      testWidgets(
        'no tasks, date is today',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          String expectedTitleDate = getTitleDateString(getDateNoTimeToday());
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
          r.dateCheckListRobot.expectTitleDate(expectedTitleDate);
        },
      );
    },
  );

  group(
    'DateCheckListScreen - swiping',
    () {
      testWidgets(
        'swipe left, no tasks, date is tomorrow',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(1);
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
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
          await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
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
          await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(3);
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
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
          await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(3);
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
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
    'DateCheckListScreen - select date',
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
          await r.tapType(DateTitle);
          await r.tapText(dateToSelect);
          await r.tapText('OK');
          r.dateCheckListRobot.expectTitleDate(expectedTitle);
        },
      );
    },
  );

  group(
    'DateCheckListScreen - task instances',
    () {
      testWidgets(
        'add a daily task, verify task instance displayed everyday',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task =
              createTestTask().copyWith(frequency: Frequency.daily);
          await r.createTaskFromDateCheckList(task);
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
          await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(2);
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
          await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(8);
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
        },
      );
    },
  );

  group(
    'DateCheckListScreen - complete',
    () {
      testWidgets(
        'add a once task, complete the task',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask();
          await r.createTaskFromDateCheckList(task);
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
          await r.tapType(Checkbox);
        },
      );
    },
  );

  group(
    'DateCheckListScreen - reschedule',
    () {
      testWidgets(
        'add a once task, verify reschedule',
        (widgetTester) async {
          // setup
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask();
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
          await r.createTaskFromDateCheckList(task);
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
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
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
          if (dateToSelect < todaysDate) {
            await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(
              todaysDate - dateToSelect,
            );
          } else {
            await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(
              dateToSelect - todaysDate,
            );
          }
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
        },
      );
    },
  );

  group(
    'DateCheckListScreen - skip',
    () {
      testWidgets(
        'add a once task, skip the task',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask();
          await r.createTaskFromDateCheckList(task);
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
          await r.skipTask(task.title);
        },
      );
    },
  );

  group(
    'DateCheckListScreen - edit',
    () {
      testWidgets(
        'add a once task, on long press open edit task screen',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          final Task task = createTestTask();
          await r.createTaskFromDateCheckList(task);
          r.dateCheckListRobot.expectFindXTaskInstanceListCards(1);
          await r.longPressText(task.title);
          await r.closePage();
        },
      );
    },
  );

  group(
    'DateCheckListScreen - app bar menu',
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
          await r.tapKey(DateAppBar.tasksMenuButtonKey);
          await r.goBack();
          await r.dateCheckListRobot.openPopupMenu();
          await r.tapKey(DateAppBar.signInMenuButtonKey);
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
          await r.tapKey(DateAppBar.tasksMenuButtonKey);
          await r.goBack();
          await r.dateCheckListRobot.openPopupMenu();
          await r.tapKey(DateAppBar.accountMenuButtonKey);
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
          await r.tapKey(DateAppBar.tasksMenuButtonKey);
          await r.goBack();
          await r.dateCheckListRobot.openPopupMenu();
          await r.tapKey(DateAppBar.signInMenuButtonKey);
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
          await r.tapKey(DateAppBar.tasksMenuButtonKey);
          await r.goBack();
          await r.dateCheckListRobot.openPopupMenu();
          await r.tapKey(DateAppBar.accountMenuButtonKey);
          await r.closePage();
        },
      );
    },
  );
}
