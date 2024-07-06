import 'package:flow/src/common_widgets/buttons/custom_text_button.dart';
import 'package:flow/src/common_widgets/buttons/primary_button.dart';
import 'package:flow/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../../../robot.dart';

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
          final r = Robot(tester);
          await r.authRobot.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );
          await r.tapType(PrimaryButton);
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
          final r = Robot(tester);
          when(() => authRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              )).thenAnswer((_) => Future.value());
          await r.authRobot.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
            onSignedIn: () => didSignIn = true,
          );
          await r.authRobot.enterEmail(testEmail);
          await r.authRobot.enterPassword(testPassword);
          await r.tapType(PrimaryButton);
          verify(() => authRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              )).called(1);
          r.authRobot.expectErrorAlertNotFound();
          expect(didSignIn, true);
        });
      });

      group('register', () {
        testWidgets('''
        Given formType is register
        When tap on the sign-in button
        Then createUserWithEmailAndPassword is not called
        ''', (tester) async {
          final r = Robot(tester);
          await r.authRobot.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.register,
          );
          await r.tapType(PrimaryButton);
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
          final r = Robot(tester);
          when(() => authRepository.createUserWithEmailAndPassword(
                testEmail,
                testPassword,
              )).thenAnswer((_) => Future.value());
          await r.authRobot.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.register,
          );
          await r.authRobot.enterEmail(testEmail);
          await r.authRobot.enterPassword(testPassword);
          await r.tapType(PrimaryButton);
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
          final r = Robot(tester);
          const password =
              'test1234'; // at least 8 characters to pass validation
          when(() => authRepository.createUserWithEmailAndPassword(
                testEmail,
                password,
              )).thenAnswer((_) => Future.value());
          await r.authRobot.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.register,
            onSignedIn: () => didSignIn = true,
          );
          await r.authRobot.enterEmail(testEmail);
          await r.authRobot.enterPassword(password);
          await r.tapType(PrimaryButton);
          verify(() => authRepository.createUserWithEmailAndPassword(
                testEmail,
                password,
              )).called(1);
          r.authRobot.expectErrorAlertNotFound();
          expect(didSignIn, true);
        });
      });

      group('updateFormType', () {
        testWidgets('''
        Given formType is sign in
        When tap on the form toggle button
        Then create account button is found
        ''', (tester) async {
          final r = Robot(tester);
          await r.authRobot.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );
          await r.tapType(CustomTextButton);
          r.authRobot.expectCreateAccountButtonFound();
        });

        testWidgets('''
        Given formType is sign in
        When tap on the form toggle button
        Then create account button is found
        ''', (tester) async {
          final r = Robot(tester);
          await r.authRobot.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.register,
          );
          await r.tapType(CustomTextButton);
          r.authRobot.expectCreateAccountButtonNotFound();
        });
      });

      group('focus changes when editing is complete', () {
        testWidgets('''
        Given formType is sign in
        When a valid email has been entered
        And the user presses enter, indicating that editing is complete
        Then the focus changes to the password field
        ''', (tester) async {
          final r = Robot(tester);
          await r.authRobot.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );
          await r.authRobot.enterEmailAndPressEnter(testEmail);
        });

        testWidgets('''
        Given formType is sign in
        When an invalid email has been entered
        And the user presses enter, indicating that editing is complete
        Then the focus DOES NOT changes to the password field
        ''', (tester) async {
          final r = Robot(tester);
          await r.authRobot.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );
          await r.authRobot.enterEmailAndPressEnter('bad-email');
        });

        testWidgets('''
        Given formType is sign in
        When a valid email has been entered
        And a valid password has been entered
        And the user presses enter, indicating that editing is complete
        Then the form submits and the user is signed in
        ''', (tester) async {
          bool didSignIn = false;
          final r = Robot(tester);
          when(() => authRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              )).thenAnswer((_) => Future.value());
          await r.authRobot.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
            onSignedIn: () => didSignIn = true,
          );
          await r.authRobot.enterEmailAndPressEnter(testEmail);
          await r.authRobot.enterPasswordAndPressEnter(testPassword);
          verify(() => authRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              )).called(1);
          r.authRobot.expectErrorAlertNotFound();
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
          final r = Robot(tester);
          when(() => authRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              )).thenAnswer((_) => Future.value());
          await r.authRobot.pumpEmailPasswordSignInContents(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn,
            onSignedIn: () => didSignIn = true,
          );
          await r.authRobot.enterEmailAndPressEnter('bad-email');
          await r.authRobot.enterPasswordAndPressEnter(testPassword);
          verifyNever(() => authRepository.signInWithEmailAndPassword(
                any(),
                any(),
              ));
          r.authRobot.expectErrorAlertNotFound();
          expect(didSignIn, false);
        });
      });
    },
  );
}
