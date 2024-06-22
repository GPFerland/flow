import 'package:flow/src/utils/style.dart';
import 'package:flow/src/common_widgets/input_fields/input_fields_utils.dart';
import 'package:flutter/material.dart';

class TitleInputField extends StatelessWidget {
  const TitleInputField({
    super.key,
    required this.titleKey,
    required this.titleController,
    this.readOnly = false,
  });

  final Key titleKey;
  final TextEditingController titleController;
  final bool readOnly;

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
      readOnly: readOnly,
    );
  }
}
