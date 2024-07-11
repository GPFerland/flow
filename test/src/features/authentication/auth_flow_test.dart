import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

void main() {
  testWidgets('Sign in and sign out flow', (tester) async {
    final r = Robot(tester);
    await r.pumpFlowApp();
    await r.createAccountFromDateCheckList();
    r.dateCheckListRobot.expectFindXCheckListCards(0);
    await r.logoutFromDateCheckList();
    r.dateCheckListRobot.expectFindXCheckListCards(0);
  });
}
