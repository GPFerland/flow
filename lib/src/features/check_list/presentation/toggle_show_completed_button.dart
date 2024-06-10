import 'package:flow/src/common_widgets/FUCK/providers/theme/show_completed_provider.dart';
import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToggleShowCompletedButton extends ConsumerWidget {
  const ToggleShowCompletedButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool showCompleted = ref.read(showCompletedProvider);

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () {
          ref.read(showCompletedProvider.notifier).updateShowCompleted(
                !showCompleted,
                context,
              );
          Navigator.of(context).pop();
        },
        child: Text(
          showCompleted ? "Hide Completed" : "Show Completed",
          style: getBodySmallOnPrimaryContainer(context),
        ),
      ),
    );
  }
}
