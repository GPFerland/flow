import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

void main() {
  testWidgets('Sign in and sign out flow', (tester) async {
    final r = Robot(tester);
    await r.pumpFlowApp();
    await r.createAccountFromCheckList();
    r.checkListRobot.expectFindXCheckListCards(0);
    await r.logoutFromCheckList();
    r.checkListRobot.expectFindXCheckListCards(0);
  });
}
