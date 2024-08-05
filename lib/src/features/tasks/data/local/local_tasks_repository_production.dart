import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class ProductionLocalTasksRepository implements LocalTasksRepository {
  ProductionLocalTasksRepository({
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

  static Future<ProductionLocalTasksRepository> makeDefault() async {
    return ProductionLocalTasksRepository(db: await openDatabase('default.db'));
  }

  static const tasksKey = 'tasksKey';

  // * create
  @override
  Future<void> createTask(Task task) async {
    final repoTasks = await fetchTasks();
    final index = _getTaskIndex(repoTasks, task.id);
    if (index == -1) {
      // if not found, create a new task
      repoTasks.add(task);
    } else {
      //todo - raise error or update the task?
    }
    _putTasks(repoTasks);
  }

  @override
  Future<void> createTasks(List<Task> tasks) async {
    final repoTasks = await fetchTasks();
    for (Task task in tasks) {
      final index = _getTaskIndex(repoTasks, task.id);
      if (index == -1) {
        // if not found, create a new task
        repoTasks.add(task);
      } else {
        //todo - raise error or update the task?
      }
    }
    _putTasks(repoTasks);
  }

  // * read
  @override
  Future<Task?> fetchTask(String taskId) async {
    final repoTasks = await fetchTasks();
    return _getTask(repoTasks, taskId);
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
  Stream<Task?> watchTask(String taskId) {
    return watchTasks().map(
      (repoTasks) => _getTask(repoTasks, taskId),
    );
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

  // * update
  @override
  Future<void> updateTask(Task task) async {
    final repoTasks = await fetchTasks();
    final index = _getTaskIndex(repoTasks, task.id);
    if (index == -1) {
      //todo - if not found, create a new task ??
    } else {
      repoTasks[index] = task;
    }
    _putTasks(repoTasks);
  }

  @override
  Future<void> updateTasks(List<Task> tasks) async {
    final repoTasks = await fetchTasks();
    for (Task task in tasks) {
      final index = _getTaskIndex(repoTasks, task.id);
      if (index == -1) {
        //todo - if not found, create a new task ??
      } else {
        repoTasks[index] = task;
      }
    }
    _putTasks(repoTasks);
  }

  // * delete
  @override
  Future<void> deleteTask(String taskId) async {
    final repoTasks = await fetchTasks();
    final index = _getTaskIndex(repoTasks, taskId);
    if (index == -1) {
      //todo - if not found, throw error???
    } else {
      repoTasks.removeAt(index);
    }
    _putTasks(repoTasks);
  }

  @override
  Future<void> deleteTasks(List<String> taskIds) async {
    final repoTasks = await fetchTasks();
    for (String taskId in taskIds) {
      final index = _getTaskIndex(repoTasks, taskId);
      if (index == -1) {
        //todo - if not found, throw error???
      } else {
        repoTasks.removeAt(index);
      }
    }
    _putTasks(repoTasks);
  }

  // * helper methods
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

  void _putTasks(List<Task> tasks) {
    store.record(tasksKey).put(
          db,
          jsonEncode(tasks.map((task) => task.toJson()).toList()),
        );
  }

  static Task? _getTask(List<Task> tasks, String taskId) {
    return tasks.firstWhereOrNull((task) => task.id == taskId);
  }

  static int _getTaskIndex(List<Task> tasks, String taskId) {
    return tasks.indexWhere((task) => task.id == taskId);
  }
}
