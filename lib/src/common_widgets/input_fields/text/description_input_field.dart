import 'package:flow/src/utils/style.dart';
import 'package:flow/src/common_widgets/input_fields/input_fields_utils.dart';
import 'package:flutter/material.dart';

class DescriptionInputField extends StatelessWidget {
  const DescriptionInputField({
    super.key,
    required this.descriptionKey,
    required this.descriptionController,
  });

  final GlobalKey<FormFieldState> descriptionKey;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: descriptionKey,
      controller: descriptionController,
      decoration: getTextInputFieldDecoration(
        labelText: 'Description',
        context: context,
      ),
      style: getTitleSmallOnPrimaryContainer(context),
      cursorHeight: cursorHeight,
    );
  }
}
