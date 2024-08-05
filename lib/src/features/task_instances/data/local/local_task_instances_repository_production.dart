import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class ProductionLocalTaskInstancesRepository
    implements LocalTaskInstancesRepository {
  ProductionLocalTaskInstancesRepository({
    required this.db,
  });

  final Database db;

  final store = StoreRef.main();

  //todo - this feels like a utility function
  static Future<Database> openDatabase(String filename) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
    } else {
      return databaseFactoryWeb.openDatabase(filename);
    }
  }

  static Future<ProductionLocalTaskInstancesRepository> makeDefault() async {
    return ProductionLocalTaskInstancesRepository(
      db: await openDatabase('default.db'),
    );
  }

  static const taskInstancesKey = 'taskInstancesKey';

  // * create
  @override
  Future<void> createTaskInstance(TaskInstance taskInstance) async {
    final repoTaskInstances = await fetchTaskInstances();
    final index = _getTaskInstanceIndex(repoTaskInstances, taskInstance.id);
    if (index == -1) {
      // if not found, create a new task instance
      repoTaskInstances.add(taskInstance);
    } else {
      //todo - raise error or update the task instance?
    }
    _putTaskInstances(repoTaskInstances);
  }

  @override
  Future<void> createTaskInstances(List<TaskInstance> taskInstances) async {
    final repoTaskInstances = await fetchTaskInstances();
    for (TaskInstance taskInstance in taskInstances) {
      final index = _getTaskInstanceIndex(repoTaskInstances, taskInstance.id);
      if (index == -1) {
        // if not found, create a new task instance
        repoTaskInstances.add(taskInstance);
      } else {
        //todo - raise error or update the task instance?
      }
    }
    _putTaskInstances(repoTaskInstances);
  }

  // * read
  @override
  Future<TaskInstance?> fetchTaskInstance(String taskInstanceId) async {
    final repoTaskInstances = await fetchTaskInstances();
    return _getTaskInstance(repoTaskInstances, taskInstanceId);
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
  Stream<TaskInstance?> watchTaskInstance(String taskInstanceId) {
    return watchTaskInstances(null).map(
      (repoTaskInstances) => _getTaskInstance(
        repoTaskInstances,
        taskInstanceId,
      ),
    );
  }

  @override
  Stream<List<TaskInstance>> watchTaskInstances(DateTime? date) {
    final record = store.record(taskInstancesKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot == null) {
        return [];
      }
      if (date == null) {
        return _decodeTaskInstancesJson(snapshot.value as String);
      } else {
        return _decodeTaskInstancesJson(snapshot.value as String)
            .where((taskInstance) => taskInstance.isDisplayed(date))
            .toList();
      }
    });
  }

  // * update
  @override
  Future<void> updateTaskInstance(TaskInstance taskInstance) async {
    final repoTaskInstances = await fetchTaskInstances();
    final index = _getTaskInstanceIndex(repoTaskInstances, taskInstance.id);
    if (index == -1) {
      //todo - if not found, create a new task instance ??
    } else {
      repoTaskInstances[index] = taskInstance;
    }
    _putTaskInstances(repoTaskInstances);
  }

  @override
  Future<void> updateTaskInstances(List<TaskInstance> taskInstances) async {
    final repoTaskInstances = await fetchTaskInstances();
    for (TaskInstance taskInstance in taskInstances) {
      final index = _getTaskInstanceIndex(repoTaskInstances, taskInstance.id);
      if (index == -1) {
        //todo - if not found, create a new task instance ??
      } else {
        repoTaskInstances[index] = taskInstance;
      }
    }
    _putTaskInstances(repoTaskInstances);
  }

  // * delete
  @override
  Future<void> deleteTaskInstance(String taskInstanceId) async {
    final repoTaskInstances = await fetchTaskInstances();
    final index = _getTaskInstanceIndex(repoTaskInstances, taskInstanceId);
    if (index == -1) {
      //todo - if not found, throw error???
    } else {
      repoTaskInstances.removeAt(index);
    }
    _putTaskInstances(repoTaskInstances);
  }

  @override
  Future<void> deleteTaskInstances(List<String> taskInstanceIds) async {
    final repoTaskInstances = await fetchTaskInstances();
    for (String taskInstanceId in taskInstanceIds) {
      final index = _getTaskInstanceIndex(repoTaskInstances, taskInstanceId);
      if (index == -1) {
        //todo - if not found, throw error???
      } else {
        repoTaskInstances.removeAt(index);
      }
    }
    _putTaskInstances(repoTaskInstances);
  }

  // * helper methods
  List<TaskInstance> _decodeTaskInstancesJson(String taskInstancesJson) {
    try {
      final List<dynamic> parsedTaskInstancesJson = jsonDecode(
        taskInstancesJson,
      );
      final List<TaskInstance> taskInstancesList = List<TaskInstance>.from(
        parsedTaskInstancesJson.map<TaskInstance>(
          (taskInstanceJson) => TaskInstance.fromJson(taskInstanceJson),
        ),
      );
      return taskInstancesList;
    } catch (exception) {
      //todo - use a custom exception here
      throw const FormatException('Invalid tasks JSON format');
    }
  }

  void _putTaskInstances(List<TaskInstance> taskInstances) {
    store.record(taskInstancesKey).put(
          db,
          jsonEncode(
            taskInstances.map((taskInstance) => taskInstance.toJson()).toList(),
          ),
        );
  }

  static TaskInstance? _getTaskInstance(
    List<TaskInstance> taskInstances,
    String taskInstanceId,
  ) {
    return taskInstances.firstWhereOrNull(
      (taskInstance) => taskInstance.id == taskInstanceId,
    );
  }

  static int _getTaskInstanceIndex(
    List<TaskInstance> taskInstances,
    String taskInstanceId,
  ) {
    return taskInstances.indexWhere(
      (taskInstance) => taskInstance.id == taskInstanceId,
    );
  }
}
