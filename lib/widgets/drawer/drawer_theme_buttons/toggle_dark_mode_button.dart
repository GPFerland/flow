import 'package:flow/data/providers/theme/dark_mode_provider.dart';
import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToggleDarkModeButton extends ConsumerWidget {
  const ToggleDarkModeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool darkMode = ref.read(darkModeProvider);

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
          ref.read(darkModeProvider.notifier).updateDarkMode(
                !darkMode,
                context,
              );
        },
        child: Text(
          darkMode ? "Light Mode" : "Dark Mode",
          style: getTitleMediumOnSecondaryContainer(context),
        ),
      ),
    );
  }
}
