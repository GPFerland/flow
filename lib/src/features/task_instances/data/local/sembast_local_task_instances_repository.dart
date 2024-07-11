import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastLocalTaskInstancesRepository
    implements LocalTaskInstancesRepository {
  SembastLocalTaskInstancesRepository(this.db);

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

  static Future<SembastLocalTaskInstancesRepository> makeDefault() async {
    return SembastLocalTaskInstancesRepository(
        await createDatabase('default.db'));
  }

  static const taskInstancesKey = 'taskInstancesKey';

  List<TaskInstance> _decodeTaskInstancesJson(String taskInstancesJson) {
    try {
      final List<dynamic> parsedTaskInstancesJson =
          jsonDecode(taskInstancesJson);
      final List<TaskInstance> taskInstancesList = List<TaskInstance>.from(
        parsedTaskInstancesJson.map<TaskInstance>(
          (taskInstanceJson) => TaskInstance.fromJson(taskInstanceJson),
        ),
      );
      return taskInstancesList;
    } catch (exception) {
      throw const FormatException('Invalid task instances JSON format');
    }
  }

  @override
  Future<void> setTaskInstances(List<TaskInstance> taskInstances) {
    return store.record(taskInstancesKey).put(
          db,
          jsonEncode(
            taskInstances.map((taskInstance) => taskInstance.toJson()).toList(),
          ),
        );
  }

  @override
  Future<List<TaskInstance>> fetchTaskInstances() async {
    final taskInstancesJson =
        await store.record(taskInstancesKey).get(db) as String?;
    if (taskInstancesJson == null) {
      return [];
    }
    return _decodeTaskInstancesJson(taskInstancesJson);
  }

  @override
  Future<TaskInstance?> fetchTaskInstance(String taskInstanceId) async {
    final taskInstances = await fetchTaskInstances();
    return taskInstances.firstWhereOrNull(
      (taskInstance) => taskInstance.id == taskInstanceId,
    );
  }

  @override
  Stream<List<TaskInstance>> watchTaskInstances({DateTime? date}) {
    final record = store.record(taskInstancesKey);
    return record.onSnapshot(db).map(
      (snapshot) {
        if (snapshot == null) {
          return [];
        }
        if (date == null) {
          return _decodeTaskInstancesJson(snapshot.value as String);
        }
        return _decodeTaskInstancesJson(snapshot.value as String).where(
          (taskInstance) {
            if (date == taskInstance.completedDate ||
                date == taskInstance.skippedDate ||
                date == taskInstance.rescheduledDate) {
              return true;
            } else if (date == taskInstance.initialDate &&
                taskInstance.rescheduledDate == null) {
              return true;
            }
            return false;
          },
        ).toList();
      },
    );
  }

  @override
  Stream<TaskInstance?> watchTaskInstance(String taskInstanceId) {
    return watchTaskInstances().map(
      (taskInstance) {
        return taskInstance.firstWhereOrNull(
          (taskInstance) => taskInstance.id == taskInstanceId,
        );
      },
    );
  }
}
