import 'package:flow/providers/theme/dark_mode_provider.dart';
import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DarkModeToggleSlider extends ConsumerWidget {
  const DarkModeToggleSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool? darkMode = ref.read(darkModeProvider);

    return SizedBox(
      height: drawerTileHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Dark Mode',
                style: getTitleLargeOnSecondaryContainer(context),
              ),
            ),
            Switch(
              value: darkMode ?? false,
              onChanged: (value) {
                ref
                    .read(darkModeProvider.notifier)
                    .updateDarkMode(value, context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
