import 'package:flow/src/constants/test_task_instances.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

void main() {
  testWidgets('Sign in and sign out flow', (tester) async {
    final r = Robot(tester);
    await r.pumpFlowApp();
    await r.signInFromDateCheckList();
    r.dateCheckListRobot.expectFindXTaskInstanceListCards(
      kTestTaskInstances.taskInstancesList.length,
    );
    await r.logoutFromDateCheckList();
    r.dateCheckListRobot.expectFindXTaskInstanceListCards(0);
  });
}
