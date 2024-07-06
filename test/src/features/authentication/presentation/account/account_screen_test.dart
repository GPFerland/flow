import 'package:flow/src/common_widgets/alert_dialogs.dart';
import 'package:flow/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../../../robot.dart';

void main() {
  group(
    'AccountScreen',
    () {
      testWidgets('Cancel logout', (tester) async {
        final r = Robot(tester);
        const mockUser = AppUser(uid: '123', email: 'test@test.com');
        final mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
        when(mockAuthRepository.authStateChanges).thenAnswer(
          (_) => Stream.value(mockUser),
        );
        await r.authRobot.pumpAccountScreen(authRepository: mockAuthRepository);
        await r.tapText('Logout');
        r.authRobot.expectLogoutDialogFound();
        await r.tapText('Cancel');
        r.authRobot.expectLogoutDialogNotFound();
      });

      testWidgets('Confirm logout, success', (tester) async {
        final r = Robot(tester);
        const mockUser = AppUser(uid: '123', email: 'test@test.com');
        final mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
        when(mockAuthRepository.authStateChanges).thenAnswer(
          (_) => Stream.value(mockUser),
        );
        await r.authRobot.pumpAccountScreen(authRepository: mockAuthRepository);
        await r.tapText('Logout');
        r.authRobot.expectLogoutDialogFound();
        await r.tapKey(kDialogDefaultKey);
        r.authRobot.expectLogoutDialogNotFound();
        //r.expectErrorAlertNotFound();
      });

      testWidgets('Confirm logout, failure', (tester) async {
        final r = Robot(tester);
        final authRepository = MockAuthRepository();
        final exception = Exception('Connection Failed');
        when(authRepository.signOut).thenThrow(exception);
        when(authRepository.authStateChanges).thenAnswer(
          (_) => Stream.value(
            const AppUser(uid: '123', email: 'test@test.com'),
          ),
        );
        await r.authRobot.pumpAccountScreen(authRepository: authRepository);
        await r.tapText('Logout');
        r.authRobot.expectLogoutDialogFound();
        await r.tapKey(kDialogDefaultKey);
        r.authRobot.expectLogoutDialogNotFound();
      });

      testWidgets('Confirm logout, loading state', (tester) async {
        final r = Robot(tester);
        final authRepository = MockAuthRepository();
        when(authRepository.signOut).thenAnswer(
          (_) => Future.delayed(const Duration(seconds: 1)),
        );
        when(authRepository.authStateChanges).thenAnswer(
          (_) => Stream.value(
            const AppUser(uid: '123', email: 'test@test.com'),
          ),
        );
        await r.authRobot.pumpAccountScreen(authRepository: authRepository);
        await tester.runAsync(() async {
          await r.tapText('Logout');
          r.authRobot.expectLogoutDialogFound();
          await r.tapKey(kDialogDefaultKey);
        });
        r.authRobot.expectCircularProgressIndicator();
      });
    },
  );
}
