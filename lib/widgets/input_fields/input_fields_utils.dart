import 'package:flutter/material.dart';

const double cursorHeight = 25;

InputDecoration getTextInputFieldDecoration({
  required String labelText,
  required Color color,
}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      color: color,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
      ),
    ),
    contentPadding: const EdgeInsets.only(
      top: 6,
      bottom: 6,
    ),
  );
}
