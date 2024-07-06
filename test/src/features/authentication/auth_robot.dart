import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/authentication/presentation/account/account_screen.dart';
import 'package:flow/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:flow/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class AuthRobot {
  AuthRobot(this.widgetTester);
  final WidgetTester widgetTester;

  Future<void> pumpEmailPasswordSignInContents({
    required TestAuthRepository authRepository,
    required EmailPasswordSignInFormType formType,
    VoidCallback? onSignedIn,
  }) {
    return widgetTester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: EmailPasswordSignInContents(
              formType: formType,
              onSignedIn: onSignedIn,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pumpAccountScreen({TestAuthRepository? authRepository}) async {
    await widgetTester.pumpWidget(
      ProviderScope(
        overrides: [
          if (authRepository != null)
            authRepositoryProvider.overrideWithValue(
              authRepository,
            )
        ],
        child: const MaterialApp(
          home: AccountScreen(),
        ),
      ),
    );
  }

  Future<void> enterEmail(String email) async {
    final emailField = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailField, findsOneWidget);
    await widgetTester.enterText(emailField, email);
    await widgetTester.pumpAndSettle();
  }

  Future<void> enterEmailAndPressEnter(String email) async {
    await enterEmail(email);
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
  }

  Future<void> enterPassword(String password) async {
    final passwordField = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(passwordField, findsOneWidget);
    await widgetTester.enterText(passwordField, password);
    await widgetTester.pumpAndSettle();
  }

  Future<void> enterPasswordAndPressEnter(String password) async {
    await enterPassword(password);
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
  }

  void expectCreateAccountButtonFound() {
    final dialogTitle = find.text('Create an account');
    expect(dialogTitle, findsOneWidget);
  }

  void expectCreateAccountButtonNotFound() {
    final dialogTitle = find.text('Create an account');
    expect(dialogTitle, findsNothing);
  }

  void expectLogoutDialogFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsOneWidget);
  }

  void expectLogoutDialogNotFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsNothing);
  }

  void expectErrorAlertFound() {
    final finder = find.text('Error');
    expect(finder, findsOneWidget);
  }

  void expectErrorAlertNotFound() {
    final finder = find.text('Error');
    expect(finder, findsNothing);
  }

  void expectCircularProgressIndicator() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }
}
