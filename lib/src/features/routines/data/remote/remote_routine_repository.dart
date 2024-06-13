import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/features/routines/domain/routines.dart';
import 'package:flow/src/utils/remote_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API for reading, watching and writing remote routine data (guest user)
abstract class RemoteRoutinesRepository {
  Future<Routines> fetchRoutines(String userId);

  Future<void> setRoutines(String userId, Routines routines);

  Stream<Routines> watchRoutines(String userId);

  Stream<Routine?> watchRoutine(String userId, String id);
}

final remoteRoutinesRepositoryProvider =
    Provider<RemoteRoutinesRepository>((ref) {
  // * Override this in the main method
  throw UnimplementedError();
});

final remoteRoutinesListStreamProvider =
    StreamProvider.autoDispose.family<Routines, String>((ref, userId) {
  // * Override this in the main method
  throw UnimplementedError();
});

final remoteRoutinesListFutureProvider =
    FutureProvider.autoDispose.family<Routines, String>((ref, userId) {
  // * Override this in the main method
  throw UnimplementedError();
});

final remoteRoutineStreamProvider =
    StreamProvider.autoDispose.family<Routine?, RemoteItem>((ref, remoteItem) {
  // * Override this in the main method
  throw UnimplementedError();
});
