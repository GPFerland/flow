import 'package:flow/utils/style.dart';
import 'package:flow/widgets/input_fields/input_fields_utils.dart';
import 'package:flutter/material.dart';

class TitleInputField extends StatelessWidget {
  const TitleInputField({
    super.key,
    required this.titleKey,
    required this.titleController,
  });

  final GlobalKey<FormFieldState> titleKey;
  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: titleKey,
      controller: titleController,
      decoration: getTextInputFieldDecoration(
        labelText: 'Title',
        context: context,
      ),
      style: getTitleSmallOnPrimaryContainer(context),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please add a title.';
        }
        return null;
      },
      cursorHeight: cursorHeight,
    );
  }
}
