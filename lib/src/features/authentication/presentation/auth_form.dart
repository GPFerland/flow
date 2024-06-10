import 'package:flow/src/utils/error.dart';
import 'package:flow/src/utils/firestore.dart';
import 'package:flow/src/utils/style.dart';
import 'package:flow/src/common_widgets/input_fields/text/email_input_field.dart';
import 'package:flow/src/common_widgets/input_fields/text/password_input_field.dart';
import 'package:flow/src/common_widgets/input_fields/text/username_input_field.dart';
import 'package:flutter/material.dart';

const double logInHeight = 250;
const double signUpHeight = 303;
const double textFieldErrorBuffer = 24;
const int defaultAnimationSpeed = 400;
const int errorAnimationSpeed = 100;

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() {
    return _AuthFormState();
  }
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _usernameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isInvalid = false;
  bool _isAuthenticating = false;

  double _formHeight = logInHeight;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _authenticate() async {
    _isInvalid = false;
    if (_form.currentState != null && !_form.currentState!.validate()) {
      _isInvalid = true;
      _calculateFormHeight();
      return;
    }

    setState(() {
      _isAuthenticating = true;
    });

    String? errorMessage;

    if (_isLogin) {
      errorMessage = await logInUser(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      errorMessage = await signUpUser(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }

    if (errorMessage != null && mounted) {
      displayErrorMessageInSnackBar(
        context: context,
        errorMessage: errorMessage,
      );
    }

    if (mounted) {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _calculateFormHeight() {
    double newHeight = _isLogin ? logInHeight : signUpHeight;

    if (!_isLogin) {
      if (!_usernameKey.currentState!.validate()) {
        newHeight += textFieldErrorBuffer;
      }
    }
    if (!_emailKey.currentState!.validate()) {
      newHeight += textFieldErrorBuffer;
    }
    if (!_passwordKey.currentState!.validate()) {
      newHeight += textFieldErrorBuffer;
    }

    setState(() {
      _formHeight = newHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: AnimatedContainer(
        duration: _isInvalid
            ? const Duration(milliseconds: errorAnimationSpeed)
            : const Duration(milliseconds: defaultAnimationSpeed),
        curve: Curves.easeInOut,
        height: _formHeight,
        child: Stack(
          children: [
            Container(
              height: _formHeight,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _isLogin ? 0.0 : 1.0,
                duration: const Duration(milliseconds: defaultAnimationSpeed),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  UsernameInputField(
                    usernameKey: _usernameKey,
                    usernameController: _usernameController,
                    resize: _calculateFormHeight,
                    validate: !_isLogin,
                  ),
                ]),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  EmailInputField(
                    emailKey: _emailKey,
                    emailController: _emailController,
                    resize: _calculateFormHeight,
                  ),
                  PasswordInputField(
                    passwordKey: _passwordKey,
                    passwordController: _passwordController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isAuthenticating ? null : _authenticate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: _isAuthenticating
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(),
                            )
                          : AnimatedCrossFade(
                              firstChild: const Text('Log in'),
                              secondChild: const Text('Sign up'),
                              crossFadeState: _isLogin
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: const Duration(
                                  milliseconds: defaultAnimationSpeed),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedCrossFade(
                        firstChild: Text(
                          'Don\'t have an account?',
                          style: getBodyMediumOnPrimaryContainer(context),
                        ),
                        secondChild: Text(
                          'Have an account?',
                          style: getBodyMediumOnPrimaryContainer(context),
                        ),
                        crossFadeState: _isLogin
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration:
                            const Duration(milliseconds: defaultAnimationSpeed),
                      ),
                      TextButton(
                        onPressed: () {
                          final String email = _emailController.text;
                          setState(() {
                            _isLogin = !_isLogin;
                            _formHeight = _isLogin ? logInHeight : signUpHeight;
                            _isInvalid = false;
                            _form.currentState!.reset();
                            _emailController.text = email;
                          });
                        },
                        child: AnimatedCrossFade(
                          firstChild: const Text('Sign up'),
                          secondChild: const Text('Log in'),
                          crossFadeState: _isLogin
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(
                              milliseconds: defaultAnimationSpeed),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
