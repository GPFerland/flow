import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';

class UntilCompletedToggleSlider extends StatelessWidget {
  const UntilCompletedToggleSlider({
    super.key,
    required this.untilCompleted,
    required this.updateUntilCompleted,
  });

  final bool untilCompleted;
  final Function(bool) updateUntilCompleted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        'Show Until Completed',
        style: getBodyLargeOnPrimaryContainer(context),
      ),
      trailing: Switch(
        value: untilCompleted,
        onChanged: (value) {
          updateUntilCompleted(value);
        },
      ),
    );
  }
}
