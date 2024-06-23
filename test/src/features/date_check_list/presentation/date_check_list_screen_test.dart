import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/date.dart';
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
          String expectedTitleDate = getDisplayDateString(getDateNoTimeToday());
          r.dateCheckListRobot.expectFindTaskInstanceListCards(0);
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
          r.dateCheckListRobot.expectFindTaskInstanceListCards(0);
          r.dateCheckListRobot.expectTitleDate(
            getDisplayDateString(getDateNoTimeTomorrow()),
          );
        },
      );

      testWidgets(
        'swipe right, no tasks, date is yesterday',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(1);
          r.dateCheckListRobot.expectFindTaskInstanceListCards(0);
          r.dateCheckListRobot.expectTitleDate(
            getDisplayDateString(getDateNoTimeYesterday()),
          );
        },
      );

      testWidgets(
        'swipe left x3, no tasks, date is three days after today',
        (widgetTester) async {
          final r = Robot(widgetTester);
          await r.pumpFlowApp();
          await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(3);
          r.dateCheckListRobot.expectFindTaskInstanceListCards(0);
          r.dateCheckListRobot.expectTitleDate(
            getDisplayDateString(
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
          r.dateCheckListRobot.expectFindTaskInstanceListCards(0);
          r.dateCheckListRobot.expectTitleDate(
            getDisplayDateString(
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
          String expectedTitle = getDisplayDateString(
            getDateNoTimeToday().copyWith(day: 11),
          );
          if (getDateNoTimeToday().day == 11) {
            dateToSelect = '22';
            expectedTitle = getDisplayDateString(
              getDateNoTimeToday().copyWith(day: 22),
            );
          }
          await r.pumpFlowApp();
          await r.dateCheckListRobot.tapTitleDate();
          await r.dateCheckListRobot.tapCalendarDate(dateToSelect);
          await r.dateCheckListRobot.tapCalendarOk();
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
          final Task task = createTestTask();
          await r.createTaskFromDateCheckListScreen(task);
          r.dateCheckListRobot.expectFindTaskInstanceListCards(1);
          await r.dateCheckListRobot.leftSwipeDateCheckListXTimes(2);
          r.dateCheckListRobot.expectFindTaskInstanceListCards(1);
          await r.dateCheckListRobot.rightSwipeDateCheckListXTimes(4);
          r.dateCheckListRobot.expectFindTaskInstanceListCards(1);
        },
      );
    },
  );
}
