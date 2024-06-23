import 'package:flow/src/features/date_check_list/presentation/check_list_app_bar/date_check_list_title.dart';
import 'package:flow/src/features/date_check_list/presentation/date_check_list_screen.dart';
import 'package:flow/src/features/date_check_list/presentation/task_instance_list_card.dart';
import 'package:flutter_test/flutter_test.dart';

class DateCheckListRobot {
  DateCheckListRobot(this.widgetTester);
  final WidgetTester widgetTester;

  Future<void> leftSwipeDateCheckListXTimes(int num) async {
    final finder = find.byKey(DateCheckListScreen.dateCheckListKey);
    expect(finder, findsOneWidget);
    for (int i = 0; i < num; i++) {
      await widgetTester.drag(finder, const Offset(-500.0, 500.0));
      await widgetTester.pumpAndSettle();
    }
  }

  Future<void> rightSwipeDateCheckListXTimes(int num) async {
    final finder = find.byKey(DateCheckListScreen.dateCheckListKey);
    expect(finder, findsOneWidget);
    for (int i = 0; i < num; i++) {
      await widgetTester.drag(finder, const Offset(500.0, -500.0));
      await widgetTester.pumpAndSettle();
    }
  }

  Future<void> tapTitleDate() async {
    final finder = find.byKey(DateCheckListTitle.dateCheckListTitleKey);
    expect(finder, findsOneWidget);
    await widgetTester.tap(finder);
    await widgetTester.pumpAndSettle();
  }

  Future<void> tapCalendarDate(String date) async {
    final finder = find.text(date);
    expect(finder, findsOneWidget);
    await widgetTester.tap(finder);
    await widgetTester.pumpAndSettle();
  }

  Future<void> tapCalendarOk() async {
    final finder = find.text('OK');
    expect(finder, findsOneWidget);
    await widgetTester.tap(finder);
    await widgetTester.pumpAndSettle();
  }

  void expectTitleDate(String date) {
    final finder = find.text(date);
    expect(finder, findsOneWidget);
  }

  void expectSelectDateDialog() {
    final finder = find.text('Select date');
    expect(finder, findsOneWidget);
  }

  void expectFindTaskInstanceListCards(int num) {
    final finder = find.byType(TaskInstanceListCard);
    expect(finder, findsNWidgets(num));
  }
}
