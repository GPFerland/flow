import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastLocalTasksRepository implements LocalTasksRepository {
  SembastLocalTasksRepository(this.db);

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

  static Future<SembastLocalTasksRepository> makeDefault() async {
    return SembastLocalTasksRepository(await createDatabase('default.db'));
  }

  static const tasksKey = 'tasksKey';

  List<Task> _decodeTasksJson(String tasksJson) {
    try {
      final List<dynamic> parsedTasksJson = jsonDecode(tasksJson);
      final List<Task> tasksList = List<Task>.from(
        parsedTasksJson.map<Task>((taskJson) => Task.fromJson(taskJson)),
      );
      return tasksList;
    } catch (exception) {
      //todo - use a custom exception here
      throw const FormatException('Invalid tasks JSON format');
    }
  }

  @override
  Future<void> setTasks(List<Task> tasks) {
    return store.record(tasksKey).put(
          db,
          jsonEncode(tasks.map((task) => task.toJson()).toList()),
        );
  }

  @override
  Future<List<Task>> fetchTasks() async {
    final tasksJson = await store.record(tasksKey).get(db) as String?;
    if (tasksJson == null) {
      return [];
    }
    return _decodeTasksJson(tasksJson);
  }

  @override
  Future<Task?> fetchTask(String taskId) async {
    final tasks = await fetchTasks();
    return tasks.firstWhereOrNull((task) => task.id == taskId);
  }

  @override
  Stream<List<Task>> watchTasks() {
    final record = store.record(tasksKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot == null) {
        return [];
      }
      return _decodeTasksJson(snapshot.value as String);
    });
  }

  @override
  Stream<Task?> watchTask(String taskId) {
    return watchTasks().map(
      (task) {
        return task.firstWhereOrNull((task) => task.id == taskId);
      },
    );
  }
}
