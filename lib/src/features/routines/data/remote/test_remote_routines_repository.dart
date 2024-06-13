import 'package:collection/collection.dart';
import 'package:flow/src/features/routines/data/remote/remote_routine_repository.dart';
import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/features/routines/domain/routines.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flow/src/utils/in_memory_store.dart';
import 'package:flow/src/utils/remote_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestRemoteRoutinesRepository implements RemoteRoutinesRepository {
  TestRemoteRoutinesRepository({this.addDelay = true});

  final bool addDelay;

  /// An InMemoryStore containing the routines data for all users, where:
  /// key: userId of the user
  /// value: Routines of that user
  final _routines = InMemoryStore<Map<String, Routines>>({});

  @override
  Future<Routines> fetchRoutines(String userId) async {
    await delay(addDelay);
    return Future.value(_routines.value[userId] ?? Routines(routinesList: []));
  }

  @override
  Future<void> setRoutines(String userId, Routines routines) async {
    _routines.value[userId] = routines;
  }

  @override
  Stream<Routines> watchRoutines(String userId) async* {
    await delay(addDelay);
    yield _routines.value[userId] ?? Routines(routinesList: []);
  }

  @override
  Stream<Routine?> watchRoutine(String userId, String id) {
    return watchRoutines(userId).map(
      (routines) => routines.routinesList.firstWhereOrNull(
        (routine) => routine.id == id,
      ),
    );
  }
}

final remoteRoutinesRepositoryProvider =
    Provider<TestRemoteRoutinesRepository>((ref) {
  return TestRemoteRoutinesRepository();
});

final remoteRoutinesListStreamProvider =
    StreamProvider.autoDispose.family<Routines, String>((ref, userId) {
  final routinesRepository = ref.watch(remoteRoutinesRepositoryProvider);
  return routinesRepository.watchRoutines(userId);
});

final remoteRoutinesListFutureProvider =
    FutureProvider.autoDispose.family<Routines, String>((ref, userId) {
  final routinesRepository = ref.watch(remoteRoutinesRepositoryProvider);
  return routinesRepository.fetchRoutines(userId);
});

final remoteRoutineStreamProvider =
    StreamProvider.autoDispose.family<Routine?, RemoteItem>((ref, remoteItem) {
  final routinesRepository = ref.watch(remoteRoutinesRepositoryProvider);
  return routinesRepository.watchRoutine(remoteItem.userId, remoteItem.itemId);
});
