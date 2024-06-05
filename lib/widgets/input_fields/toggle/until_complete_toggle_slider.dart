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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  'Show Until Completed',
                  style: getTitleSmallOnPrimaryContainer(context),
                ),
                //todo - this isnt working like I would expect???
                // const SizedBox(width: 8),
                // Tooltip(
                //   message: 'Test.',
                //   triggerMode: TooltipTriggerMode.tap,
                //   child: IconButton(
                //     icon: const Icon(Icons.info, size: 18),
                //     onPressed: () {},
                //   ),
                // ),
              ],
            ),
          ),
          Switch(
            value: untilCompleted,
            onChanged: (value) {
              updateUntilCompleted(value);
            },
          ),
        ],
      ),
    );
  }
}
