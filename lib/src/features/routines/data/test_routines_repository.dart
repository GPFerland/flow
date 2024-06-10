import 'package:flow/src/constants/test_routines.dart';
import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeRoutinesRepository {
  final List<Routine> _routines = kTestRoutines;

  List<Routine> getRoutinesList() {
    return _routines;
  }

  Routine? getRoutine(String id) {
    return _routines.firstWhere((routine) => routine.id == id);
  }

  Future<List<Routine>> fetchRoutinesList() async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(_routines);
  }

  Stream<List<Routine>> watchRoutinesList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _routines;
  }

  Stream<Routine?> watchRoutine(String id) {
    return watchRoutinesList()
        .map((routines) => routines.firstWhere((routine) => routine.id == id));
  }
}

final routinesRepositoryProvider = Provider<FakeRoutinesRepository>((ref) {
  return FakeRoutinesRepository();
});

final routinesListStreamProvider =
    StreamProvider.autoDispose<List<Routine>>((ref) {
  final routinesRepository = ref.watch(routinesRepositoryProvider);
  return routinesRepository.watchRoutinesList();
});

final routinesListFutureProvider =
    FutureProvider.autoDispose<List<Routine>>((ref) {
  final routinesRepository = ref.watch(routinesRepositoryProvider);
  return routinesRepository.fetchRoutinesList();
});

final routineStreamProvider =
    StreamProvider.autoDispose.family<Routine?, String>((ref, id) {
  final routinesRepository = ref.watch(routinesRepositoryProvider);
  return routinesRepository.watchRoutine(id);
});
