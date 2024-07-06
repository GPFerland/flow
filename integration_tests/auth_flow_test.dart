import 'package:flow/src/features/date_check_list/presentation/date_app_bar/date_app_bar.dart';
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
    await r.dateCheckListRobot.openPopupMenu();
    await r.tapKey(DateAppBar.signInMenuButtonKey);
    await r.authRobot.enterEmail('test@email.com');
    await r.authRobot.enterPassword('password');
    await r.tapText('Create');
    //r.expectFindAllProductCards();
    await r.dateCheckListRobot.openPopupMenu();
    await r.tapKey(DateAppBar.accountMenuButtonKey);
    await r.tapText('Logout');
    await r.tapText('Logout');
    //r.expectFindAllProductCards();
  });
}
