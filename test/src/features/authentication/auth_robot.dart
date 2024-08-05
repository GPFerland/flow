import 'package:flow/src/common_widgets/alert_dialogs.dart';
import 'package:flow/src/common_widgets/buttons/custom_text_button.dart';
import 'package:flow/src/common_widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class AuthRobot {
  AuthRobot(this.widgetTester);
  final WidgetTester widgetTester;

  Future<void> tapEmailAndPasswordSubmitButton() async {
    final primaryButton = find.byType(PrimaryButton);
    expect(primaryButton, findsOneWidget);
    await widgetTester.tap(primaryButton);
    await widgetTester.pumpAndSettle();
  }

  Future<void> tapFormToggleButton() async {
    final toggleButton = find.byType(CustomTextButton);
    expect(toggleButton, findsOneWidget);
    await widgetTester.tap(toggleButton);
    await widgetTester.pumpAndSettle();
  }

  Future<void> enterEmail(String email) async {
    // final emailField = find.byKey(EmailPasswordSignInScreen.emailKey);
    // expect(emailField, findsOneWidget);
    // await widgetTester.enterText(emailField, email);
    // await widgetTester.pumpAndSettle();
  }

  Future<void> enterEmailAndPressEnter(String email) async {
    await enterEmail(email);
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
  }

  Future<void> enterPassword(String password) async {
    // final passwordField = find.byKey(EmailPasswordSignInScreen.passwordKey);
    // expect(passwordField, findsOneWidget);
    // await widgetTester.enterText(passwordField, password);
    // await widgetTester.pumpAndSettle();
  }

  Future<void> enterPasswordAndPressEnter(String password) async {
    await enterPassword(password);
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
  }

  Future<void> tapLogoutButton() async {
    final logoutButton = find.text('Logout');
    expect(logoutButton, findsOneWidget);
    await widgetTester.tap(logoutButton);
    await widgetTester.pump();
  }

  void expectLogoutDialogFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsOneWidget);
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
    await widgetTester.tap(cancelButton);
    await widgetTester.pump();
  }

  void expectLogoutDialogNotFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsNothing);
  }

  Future<void> tapDialogLogoutButton() async {
    final logoutButton = find.byKey(kDialogDefaultKey);
    expect(logoutButton, findsOneWidget);
    await widgetTester.tap(logoutButton);
    await widgetTester.pump();
  }

  void expectCreateAccountButtonFound() {
    final dialogTitle = find.text('Create an account');
    expect(dialogTitle, findsOneWidget);
  }

  void expectCreateAccountButtonNotFound() {
    final dialogTitle = find.text('Create an account');
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
