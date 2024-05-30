import 'package:flow/providers/models/occurrences_provider.dart';
import 'package:flow/providers/models/routines_provider.dart';
import 'package:flow/providers/models/tasks_provider.dart';
import 'package:flow/providers/theme/color_provider.dart';
import 'package:flow/providers/theme/dark_mode_provider.dart';
import 'package:flow/providers/theme/show_completed_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataFutureProvider = FutureProvider<void>((ref) async {
  await ref.read(darkModeProvider.notifier).getDarkMode();
  await ref.read(colorProvider.notifier).getColor();
  await ref.read(showCompletedProvider.notifier).getShowCompleted();
  await ref.read(occurrencesProvider.notifier).getOccurrences();
  await ref.read(tasksProvider.notifier).getTasks();
  await ref.read(routinesProvider.notifier).getRoutines();
});
