import 'package:flow/src/common_widgets/FUCK/providers/screen/screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackIconButton extends ConsumerWidget {
  const BackIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref.read(screenProvider.notifier).setScreen(
              AppScreen.checkList,
            );
      },
      icon: const Icon(Icons.arrow_back_outlined),
    );
  }
}
