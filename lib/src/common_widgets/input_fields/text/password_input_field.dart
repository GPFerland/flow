import 'package:flow/src/common_widgets/input_fields/input_fields_utils.dart';
import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  const PasswordInputField({
    super.key,
    required this.passwordKey,
    required this.passwordController,
  });

  final GlobalKey<FormFieldState> passwordKey;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: passwordKey,
      controller: passwordController,
      decoration: getTextInputFieldDecoration(
        labelText: 'Password',
        context: context,
      ),
      validator: (value) {
        if (value == null || value.trim().length < 6) {
          return 'Password must be at least 6 characters long.';
        }
        return null;
      },
      cursorHeight: cursorHeight,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
    );
  }
}
