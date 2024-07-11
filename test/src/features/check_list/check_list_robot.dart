import 'package:flow/src/features/check_list/presentation/app_bar/compact_menu_buttons.dart';
import 'package:flow/src/features/check_list/presentation/check_list_screen.dart';
import 'package:flow/src/features/check_list/presentation/check_list/card/check_list_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

class CheckListRobot {
  CheckListRobot(this.widgetTester);
  final WidgetTester widgetTester;

  Future<void> swipeDateCheckListXTimes(
    int num,
    SwipeDirection swipeDirection,
  ) async {
    final finder = find.byKey(CheckListScreen.dateCheckListKey);
    expect(finder, findsOneWidget);

    final checkListSize = widgetTester.getSize(finder);
    final leftOffset = Offset(
      checkListSize.width * 0.2,
      checkListSize.height / 2,
    );
    final rightOffset = Offset(
      checkListSize.width * 0.8,
      checkListSize.height / 2,
    );

    for (int i = 0; i < num; i++) {
      if (swipeDirection == SwipeDirection.left) {
        await widgetTester.dragFrom(rightOffset, leftOffset - rightOffset);
      } else if (swipeDirection == SwipeDirection.right) {
        await widgetTester.dragFrom(leftOffset, rightOffset - leftOffset);
      }
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

  void expectFindXCheckListCards(int num) {
    final finder = find.byType(CheckListCard);
    expect(finder, findsNWidgets(num));
  }
}
