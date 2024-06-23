import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

void main() {
  //todo - this test is broken
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Sign in and sign out flow', (tester) async {
    final r = Robot(tester);
    await r.pumpFlowApp();
    //r.expectFindAllProductCards();
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
