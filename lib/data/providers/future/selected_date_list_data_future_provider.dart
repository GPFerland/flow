import 'package:flow/data/providers/models/occurrences_provider.dart';
import 'package:flow/data/providers/models/routines_provider.dart';
import 'package:flow/data/providers/models/tasks_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDateListDataFutureProvider = FutureProvider<void>((ref) async {
  await ref.read(occurrencesProvider.notifier).getOccurrences();
  await ref.read(tasksProvider.notifier).getTasks();
  await ref.read(routinesProvider.notifier).getRoutines();
  await Future.delayed(const Duration(milliseconds: 2000));
});
