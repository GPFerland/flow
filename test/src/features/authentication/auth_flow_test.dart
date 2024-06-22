import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

void main() {
  testWidgets('Sign in and sign out flow', (tester) async {
    final r = Robot(tester);
    await r.pumpFlowApp();
    await r.openPopupMenu();
    await r.authRobot.openEmailPasswordSignInScreen();
    await r.authRobot.signInWithEmailAndPassword();
    //r.expectFindAllProductCards();
    await r.openPopupMenu();
    await r.authRobot.openAccountScreen();
    await r.authRobot.tapLogoutButton();
    await r.authRobot.tapDialogLogoutButton();
    //r.expectFindAllProductCards();
  });
}
