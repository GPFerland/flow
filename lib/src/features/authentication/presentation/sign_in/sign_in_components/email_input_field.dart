import 'package:email_validator/email_validator.dart';
import 'package:flow/src/utils/input_fields_utils.dart';
import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {
  const EmailInputField({
    super.key,
    required this.emailKey,
    required this.emailController,
    required this.resize,
  });

  final GlobalKey<FormFieldState> emailKey;
  final TextEditingController emailController;
  final void Function() resize;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: emailKey,
      controller: emailController,
      decoration: getTextInputFieldDecoration(
        labelText: 'Email',
        context: context,
      ),
      validator: (value) {
        if (value == null || !EmailValidator.validate(value)) {
          return 'Please enter a valid email address.';
        }
        return null;
      },
      cursorHeight: cursorHeight,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
    );
  }
}
