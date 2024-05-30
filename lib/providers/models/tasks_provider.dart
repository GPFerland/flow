import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/models/routine.dart';
import 'package:flow/models/task.dart';
import 'package:flow/providers/models/base_models_provider.dart';
import 'package:flow/utils/firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class TasksNotifier extends BaseModelNotifier<Task> {
  TasksNotifier() : super();

  @override
  CollectionReference<Task> getCollectionRef() {
    return getTaskCollectionRef();
  }

  Future<void> getTasks() async {
    state = await getItems()
      ..sort(
        (a, b) => a.priority!.compareTo(b.priority!),
      );
  }

  void createTask(
    Task task,
    BuildContext context,
  ) async {
    createItem(task, context);
  }

  void updateTask(
    Task task,
    BuildContext context,
  ) async {
    updateItem(task, context);
  }

  void updateTasks(
    List<Task> tasks,
    BuildContext context,
  ) async {
    updateItems(tasks, context);
  }

  void deleteTask(
    Task task,
    BuildContext context,
  ) async {
    deleteItem(task, context);
  }

  void removeRoutineFromTasks(
    Routine routine,
    BuildContext context,
  ) {
    List<Task> tasksToUpdate = List<Task>.empty(growable: true);

    for (final task in state) {
      if (routine.id == task.routineId) {
        task.removeRoutineFromTask();
        tasksToUpdate.add(task);
      }
    }

    updateTasks(tasksToUpdate, context);
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>(
  (ref) {
    return TasksNotifier();
  },
);
