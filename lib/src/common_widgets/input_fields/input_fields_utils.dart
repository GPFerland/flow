import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';

const double cursorHeight = 25;

InputDecoration getTextInputFieldDecoration({
  required String labelText,
  required BuildContext context,
}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: getTitleSmallOnPrimaryContainer(context),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    ),
    contentPadding: const EdgeInsets.only(
      top: 6,
      bottom: 6,
    ),
  );
}
