import 'package:collection/collection.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastTasksRepository implements LocalTasksRepository {
  SembastTasksRepository(this.db);
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

  static Future<SembastTasksRepository> makeDefault() async {
    return SembastTasksRepository(await createDatabase('default.db'));
  }

  static const tasksKey = 'tasksKey';

  @override
  Future<Task?> fetchTask(String id) async {
    final tasksJson = await store.record(tasksKey).get(db) as String?;
    if (tasksJson != null) {
      return Tasks.fromJson(tasksJson)
          .tasksList
          .firstWhereOrNull((task) => task.id == id);
    }
    return null;
  }

  @override
  Future<Tasks> fetchTasks() async {
    final tasksJson = await store.record(tasksKey).get(db) as String?;
    if (tasksJson != null) {
      return Tasks.fromJson(tasksJson);
    } else {
      return Tasks(tasksList: []);
    }
  }

  @override
  Future<void> setTasks(Tasks tasks) {
    return store.record(tasksKey).put(db, tasks.toJson());
  }

  @override
  Stream<Task?> watchTask(String id) {
    final record = store.record(tasksKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Tasks.fromJson(snapshot.value as String)
            .tasksList
            .firstWhereOrNull((task) => task.id == id);
      } else {
        return null;
      }
    });
  }

  @override
  Stream<Tasks> watchTasks() {
    final record = store.record(tasksKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Tasks.fromJson(snapshot.value as String);
      } else {
        return Tasks(tasksList: []);
      }
    });
  }
}
