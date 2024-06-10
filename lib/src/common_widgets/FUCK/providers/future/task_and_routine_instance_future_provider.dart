import 'package:flow/src/common_widgets/FUCK/providers/models/routine_instance_creation_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskAndRoutineInstanceFutureProvider =
    FutureProvider.family<void, DateTime>((ref, date) async {
  final creationService = ref.watch(routineInstanceCreationProvider);
  await creationService.createMissingInstances(date);
});
