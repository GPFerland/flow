import 'package:flow/src/common_widgets/input_fields/input_fields_utils.dart';
import 'package:flutter/material.dart';

class UsernameInputField extends StatelessWidget {
  const UsernameInputField({
    super.key,
    required this.usernameKey,
    required this.usernameController,
    required this.resize,
    required this.validate,
  });

  final GlobalKey<FormFieldState> usernameKey;
  final TextEditingController usernameController;
  final void Function() resize;
  final bool validate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: usernameKey,
      controller: usernameController,
      decoration: getTextInputFieldDecoration(
        labelText: 'Username',
        context: context,
      ),
      validator: (value) {
        if (!validate) {
          return null;
        }
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a username.';
        }
        return null;
      },
      cursorHeight: cursorHeight,
      enableSuggestions: false,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
    );
  }
}
