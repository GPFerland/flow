import 'package:flow/src/constants/test_routines.dart';
import 'package:flow/src/features/routines/data/local/test_local_routines_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestLocalRoutinesRepository makeRoutinesRepository() =>
      TestLocalRoutinesRepository(
        addDelay: false,
      );

  group('TestRoutinesRepository', () {
    test('fetchRoutinesList returns global list', () async {
      final routinesRepository = makeRoutinesRepository();
      expect(
        await routinesRepository.fetchRoutines(),
        kTestRoutines,
      );
    });

    test('watchRoutinesList emits global list', () {
      final routinesRepository = makeRoutinesRepository();
      expect(
        routinesRepository.watchRoutines(),
        emits(kTestRoutines),
      );
    });

    test('watchRoutine(1) emits first item', () {
      final routinesRepository = makeRoutinesRepository();
      expect(
        routinesRepository.watchRoutine('1'),
        emits(kTestRoutines.routinesList[0]),
      );
    });

    test('watchRoutine(100) emits null', () {
      final routinesRepository = makeRoutinesRepository();
      expect(
        routinesRepository.watchRoutine('100'),
        emits(null),
      );
    });
  });
}
