import 'package:collection/collection.dart';
import 'package:flow/src/features/routines/data/local/local_routines_repository.dart';
import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/features/routines/domain/routines.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastRoutinesRepository implements LocalRoutinesRepository {
  SembastRoutinesRepository(this.db);
  final Database db;
  final store = StoreRef.main();

  static Future<Database> createDatabase(String filename) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
    } else {
      return databaseFactoryWeb.openDatabase(filename);
    }
  }

  static Future<SembastRoutinesRepository> makeDefault() async {
    return SembastRoutinesRepository(await createDatabase('default.db'));
  }

  static const routinesKey = 'routinesKey';

  @override
  Future<Routines> fetchRoutines() async {
    final routinesJson = await store.record(routinesKey).get(db) as String?;
    if (routinesJson != null) {
      return Routines.fromJson(routinesJson);
    } else {
      return Routines(routinesList: []);
    }
  }

  @override
  Future<void> setRoutines(Routines routines) {
    return store.record(routinesKey).put(db, routines.toJson());
  }

  @override
  Stream<Routine?> watchRoutine(String id) {
    final record = store.record(routinesKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Routines.fromJson(snapshot.value as String)
            .routinesList
            .firstWhereOrNull((routine) => routine.id == id);
      } else {
        return null;
      }
    });
  }

  @override
  Stream<Routines> watchRoutines() {
    final record = store.record(routinesKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Routines.fromJson(snapshot.value as String);
      } else {
        return Routines(routinesList: []);
      }
    });
  }
}
