import 'package:flow/providers/theme/color_provider.dart';
import 'package:flow/providers/theme/dark_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userThemeFutureProvider = FutureProvider<void>((ref) async {
  await ref.read(darkModeProvider.notifier).getDarkMode();
  await ref.read(colorProvider.notifier).getColor();
  //todo - this is to make sure the theme is set but there has to be a cleaner way to do this fuck
  await Future.delayed(const Duration(seconds: 1));
});
