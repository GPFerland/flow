import 'package:flow/src/features/date_check_list/presentation/date_app_bar/compact_menu_buttons.dart';
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
      await widgetTester.drag(finder, const Offset(-750.0, 500.0));
      await widgetTester.pumpAndSettle();
    }
  }

  Future<void> rightSwipeDateCheckListXTimes(int num) async {
    final finder = find.byKey(DateCheckListScreen.dateCheckListKey);
    expect(finder, findsOneWidget);
    for (int i = 0; i < num; i++) {
      await widgetTester.drag(finder, const Offset(750.0, -500.0));
      await widgetTester.pumpAndSettle();
    }
  }

  Future<void> openPopupMenu() async {
    final finder = find.byType(CompactMenuButtons);
    final matches = finder.evaluate();
    // if an item is found, it means that we're running
    // on a small window and can tap to reveal the menu
    if (matches.isNotEmpty) {
      await widgetTester.tap(finder);
      await widgetTester.pumpAndSettle();
    }
    // else no-op, as the items are already visible
  }

  void expectTitleDate(String date) {
    final finder = find.text(date);
    expect(finder, findsOneWidget);
  }

  void expectSelectDateDialog() {
    final finder = find.text('Select date');
    expect(finder, findsOneWidget);
  }

  void expectFindXTaskInstanceListCards(int num) {
    final finder = find.byType(TaskInstanceListCard);
    expect(finder, findsNWidgets(num));
  }
}
