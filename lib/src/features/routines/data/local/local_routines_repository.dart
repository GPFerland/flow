import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/features/routines/domain/routines.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API for reading, watching and writing local routine data (guest user)
abstract class LocalRoutinesRepository {
  Future<Routines> fetchRoutines();

  Future<void> setRoutines(Routines routines);

  Stream<Routines> watchRoutines();

  Stream<Routine?> watchRoutine(String id);
}

final localRoutinesRepositoryProvider =
    Provider<LocalRoutinesRepository>((ref) {
  // * Override in main()
  throw UnimplementedError();
});

final localRoutinesStreamProvider = StreamProvider.autoDispose<Routines>((ref) {
  final routinesRepository = ref.watch(localRoutinesRepositoryProvider);
  return routinesRepository.watchRoutines();
});

final localRoutinesFutureProvider = FutureProvider.autoDispose<Routines>((ref) {
  final routinesRepository = ref.watch(localRoutinesRepositoryProvider);
  return routinesRepository.fetchRoutines();
});

final localRoutineStreamProvider =
    StreamProvider.autoDispose.family<Routine?, String>((ref, id) {
  final routinesRepository = ref.watch(localRoutinesRepositoryProvider);
  return routinesRepository.watchRoutine(id);
});
