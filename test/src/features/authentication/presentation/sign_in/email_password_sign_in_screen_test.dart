import 'package:flow/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  late MockAuthRepository authRepository;
  setUp(() {
    authRepository = MockAuthRepository();
  });
  group(
    'EmailPasswordSignInScreen',
    () {
      group('sign in', () {
        testWidgets('''
        Given formType is signIn
        When tap on the sign-in button
        Then signInWithEmailAndPassword is not called
        ''', (tester) async {
          final r = AuthRobot(tester);
          await r.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );
          await r.tapEmailAndPasswordSubmitButton();
          verifyNever(() => authRepository.signInWithEmailAndPassword(
                any(),
                any(),
              ));
        });

        testWidgets('''
        Given formType is signIn
        When enter valid email and password
        And tap on the sign-in button
        Then signInWithEmailAndPassword is called
        And onSignedIn callback is called
        And error alert is not shown
        ''', (tester) async {
          var didSignIn = false;
          final r = AuthRobot(tester);
          when(() => authRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              )).thenAnswer((_) => Future.value());
          await r.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
            onSignedIn: () => didSignIn = true,
          );
          await r.enterEmail(testEmail);
          await r.enterPassword(testPassword);
          await r.tapEmailAndPasswordSubmitButton();
          verify(() => authRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              )).called(1);
          r.expectErrorAlertNotFound();
          expect(didSignIn, true);
        });
      });

      group('register', () {
        testWidgets('''
        Given formType is register
        When tap on the sign-in button
        Then createUserWithEmailAndPassword is not called
        ''', (tester) async {
          final r = AuthRobot(tester);
          await r.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.register,
          );
          await r.tapEmailAndPasswordSubmitButton();
          verifyNever(() => authRepository.createUserWithEmailAndPassword(
                any(),
                any(),
              ));
        });

        testWidgets('''
        Given formType is register
        When enter valid email
        And enter password that is too short
        And tap on the sign-in button
        Then createUserWithEmailAndPassword is called
        And onSignedIn callback is called
        And error alert is not shown
        ''', (tester) async {
          final r = AuthRobot(tester);
          when(() => authRepository.createUserWithEmailAndPassword(
                testEmail,
                testPassword,
              )).thenAnswer((_) => Future.value());
          await r.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.register,
          );
          await r.enterEmail(testEmail);
          await r.enterPassword(testPassword);
          await r.tapEmailAndPasswordSubmitButton();
          verifyNever(() => authRepository.createUserWithEmailAndPassword(
                any(),
                any(),
              ));
        });

        testWidgets('''
        Given formType is register
        When enter valid email
        And enter password that is long enough
        And tap on the sign-in button
        Then createUserWithEmailAndPassword is called
        And onSignedIn callback is called
        And error alert is not shown
        ''', (tester) async {
          var didSignIn = false;
          final r = AuthRobot(tester);
          const password =
              'test1234'; // at least 8 characters to pass validation
          when(() => authRepository.createUserWithEmailAndPassword(
                testEmail,
                password,
              )).thenAnswer((_) => Future.value());
          await r.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.register,
            onSignedIn: () => didSignIn = true,
          );
          await r.enterEmail(testEmail);
          await r.enterPassword(password);
          await r.tapEmailAndPasswordSubmitButton();
          verify(() => authRepository.createUserWithEmailAndPassword(
                testEmail,
                password,
              )).called(1);
          r.expectErrorAlertNotFound();
          expect(didSignIn, true);
        });
      });

      group('updateFormType', () {
        testWidgets('''
        Given formType is sign in
        When tap on the form toggle button
        Then create account button is found
        ''', (tester) async {
          final r = AuthRobot(tester);
          await r.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );
          await r.tapFormToggleButton();
          r.expectCreateAccountButtonFound();
        });

        testWidgets('''
        Given formType is sign in
        When tap on the form toggle button
        Then create account button is found
        ''', (tester) async {
          final r = AuthRobot(tester);
          await r.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.register,
          );
          await r.tapFormToggleButton();
          r.expectCreateAccountButtonNotFound();
        });
      });

      group('focus changes when editing is complete', () {
        testWidgets('''
        Given formType is sign in
        When a valid email has been entered
        And the user presses enter, indicating that editing is complete
        Then the focus changes to the password field
        ''', (tester) async {
          final r = AuthRobot(tester);
          await r.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );
          await r.enterEmailAndPressEnter(testEmail);
        });

        testWidgets('''
        Given formType is sign in
        When an invalid email has been entered
        And the user presses enter, indicating that editing is complete
        Then the focus DOES NOT changes to the password field
        ''', (tester) async {
          final r = AuthRobot(tester);
          await r.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );
          await r.enterEmailAndPressEnter('bad-email');
        });

        testWidgets('''
        Given formType is sign in
        When a valid email has been entered
        And a valid password has been entered
        And the user presses enter, indicating that editing is complete
        Then the form submits and the user is signed in
        ''', (tester) async {
          bool didSignIn = false;
          final r = AuthRobot(tester);
          when(() => authRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              )).thenAnswer((_) => Future.value());
          await r.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
            onSignedIn: () => didSignIn = true,
          );
          await r.enterEmailAndPressEnter(testEmail);
          await r.enterPasswordAndPressEnter(testPassword);
          verify(() => authRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              )).called(1);
          r.expectErrorAlertNotFound();
          expect(didSignIn, true);
        });

        testWidgets('''
        Given formType is sign in
        When an invalid email has been entered
        And a valid password has been entered
        And the user presses enter, indicating that editing is complete
        Then the focus changes back to the email field
        And the form is not submitted
        And the user is not signed in
        ''', (tester) async {
          bool didSignIn = false;
          final r = AuthRobot(tester);
          when(() => authRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              )).thenAnswer((_) => Future.value());
          await r.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
            onSignedIn: () => didSignIn = true,
          );
          await r.enterEmailAndPressEnter('bad-email');
          await r.enterPasswordAndPressEnter(testPassword);
          verifyNever(() => authRepository.signInWithEmailAndPassword(
                any(),
                any(),
              ));
          r.expectErrorAlertNotFound();
          expect(didSignIn, false);
        });
      });
    },
  );
}
