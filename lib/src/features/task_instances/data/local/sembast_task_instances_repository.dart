import 'package:collection/collection.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastTaskInstancesRepository implements LocalTaskInstancesRepository {
  SembastTaskInstancesRepository(this.db);
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

  static Future<SembastTaskInstancesRepository> makeDefault() async {
    return SembastTaskInstancesRepository(await createDatabase('default.db'));
  }

  static const taskInstancesKey = 'taskInstancesKey';

  @override
  Future<TaskInstance?> fetchTaskInstance(String id) async {
    final taskInstancesJson =
        await store.record(taskInstancesKey).get(db) as String?;
    if (taskInstancesJson != null) {
      return TaskInstances.fromJson(taskInstancesJson)
          .taskInstancesList
          .firstWhereOrNull((taskInstance) => taskInstance.id == id);
    }
    return null;
  }

  @override
  Future<TaskInstances> fetchTaskInstances() async {
    final taskInstancesJson =
        await store.record(taskInstancesKey).get(db) as String?;
    if (taskInstancesJson != null) {
      return TaskInstances.fromJson(taskInstancesJson);
    } else {
      return TaskInstances(taskInstancesList: []);
    }
  }

  @override
  Future<void> setTaskInstances(TaskInstances taskInstances) {
    return store.record(taskInstancesKey).put(db, taskInstances.toJson());
  }

  @override
  Stream<TaskInstance?> watchTaskInstance(String id) {
    final record = store.record(taskInstancesKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return TaskInstances.fromJson(snapshot.value as String)
            .taskInstancesList
            .firstWhereOrNull((taskInstance) => taskInstance.id == id);
      } else {
        return null;
      }
    });
  }

  @override
  Stream<TaskInstances> watchTaskInstances() {
    final record = store.record(taskInstancesKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return TaskInstances.fromJson(snapshot.value as String);
      } else {
        return TaskInstances(taskInstancesList: []);
      }
    });
  }

  @override
  Stream<TaskInstances> watchDateTaskInstances(DateTime date) {
    final record = store.record(taskInstancesKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        final taskInstances = TaskInstances.fromJson(snapshot.value as String);
        final taskInstancesList = taskInstances.taskInstancesList;
        List<TaskInstance> dateTaskInstancesList = List.empty(growable: true);

        for (TaskInstance taskInstance in taskInstancesList) {
          if (date == taskInstance.completedDate ||
              date == taskInstance.skippedDate ||
              date == taskInstance.rescheduledDate) {
            dateTaskInstancesList.add(taskInstance);
          } else if (date == taskInstance.initialDate &&
              taskInstance.rescheduledDate == null) {
            dateTaskInstancesList.add(taskInstance);
          }
        }

        return TaskInstances(taskInstancesList: dateTaskInstancesList);
      } else {
        return TaskInstances(taskInstancesList: []);
      }
    });
  }
}
