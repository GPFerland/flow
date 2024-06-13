import 'package:collection/collection.dart';
import 'package:flow/src/constants/test_routines.dart';
import 'package:flow/src/features/routines/data/local/local_routines_repository.dart';
import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/features/routines/domain/routines.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestLocalRoutinesRepository implements LocalRoutinesRepository {
  TestLocalRoutinesRepository({this.addDelay = true});

  final bool addDelay;

  Routines _routines = kTestRoutines;

  @override
  Future<Routines> fetchRoutines() async {
    await delay(addDelay);
    return Future.value(_routines);
  }

  @override
  Future<void> setRoutines(Routines routines) async {
    _routines = routines;
  }

  @override
  Stream<Routines> watchRoutines() async* {
    await delay(addDelay);
    yield _routines;
  }

  @override
  Stream<Routine?> watchRoutine(String id) {
    return watchRoutines().map(
      (routines) => routines.routinesList.firstWhereOrNull(
        (routine) => routine.id == id,
      ),
    );
  }
}

final testLocalRoutinesRepositoryProvider =
    Provider<TestLocalRoutinesRepository>((ref) {
  return TestLocalRoutinesRepository();
});
