import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';

void displayErrorMessageInSnackBar({
  required BuildContext context,
  required String errorMessage,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      content: Text(
        errorMessage,
        textAlign: TextAlign.center,
        style: getBodyMediumOnPrimaryContainer(context),
      ),
    ),
  );
}
