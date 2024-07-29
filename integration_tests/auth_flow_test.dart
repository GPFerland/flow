import 'package:flow/src/features/check_list/presentation/app_bar/check_list_app_bar.dart';
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
    await r.checkListRobot.openPopupMenu();
    await r.tapKey(CheckListAppBar.signInMenuButtonKey);
    await r.authRobot.enterEmail('test@email.com');
    await r.authRobot.enterPassword('password');
    await r.tapText('Create');
    //r.expectFindAllProductCards();
    await r.checkListRobot.openPopupMenu();
    await r.tapKey(CheckListAppBar.accountMenuButtonKey);
    await r.tapText('Logout');
    await r.tapText('Logout');
    //r.expectFindAllProductCards();
  });
}
