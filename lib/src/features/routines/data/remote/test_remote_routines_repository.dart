import 'package:collection/collection.dart';
import 'package:flow/src/constants/test_routines.dart';
import 'package:flow/src/features/routines/data/remote/remote_routine_repository.dart';
import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/features/routines/domain/routines.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flow/src/utils/remote_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestRemoteRoutinesRepository implements RemoteRoutinesRepository {
  TestRemoteRoutinesRepository({this.addDelay = true});

  final bool addDelay;
  Routines _routines = kTestRoutines;

  @override
  Future<Routines> fetchRoutines(String userId) async {
    await delay(addDelay);
    return Future.value(_routines);
  }

  @override
  Future<void> setRoutines(String userId, Routines routines) async {
    _routines = routines;
  }

  @override
  Stream<Routines> watchRoutines(String userId) async* {
    await delay(addDelay);
    yield _routines;
  }

  @override
  Stream<Routine?> watchRoutine(String uid, String id) {
    return watchRoutines(uid).map(
      (routines) => routines.routinesList.firstWhereOrNull(
        (routine) => routine.id == id,
      ),
    );
  }
}

final testRemoteRoutinesRepositoryProvider =
    Provider<TestRemoteRoutinesRepository>((ref) {
  return TestRemoteRoutinesRepository();
});

final testRemoteRoutinesListStreamProvider =
    StreamProvider.autoDispose.family<Routines, String>((ref, userId) {
  final routinesRepository = ref.watch(testRemoteRoutinesRepositoryProvider);
  return routinesRepository.watchRoutines(userId);
});

final testRemoteRoutinesListFutureProvider =
    FutureProvider.autoDispose.family<Routines, String>((ref, userId) {
  final routinesRepository = ref.watch(testRemoteRoutinesRepositoryProvider);
  return routinesRepository.fetchRoutines(userId);
});

final testRemoteRoutineStreamProvider =
    StreamProvider.autoDispose.family<Routine?, RemoteItem>((ref, remoteItem) {
  final routinesRepository = ref.watch(testRemoteRoutinesRepositoryProvider);
  return routinesRepository.watchRoutine(remoteItem.userId, remoteItem.itemId);
});
