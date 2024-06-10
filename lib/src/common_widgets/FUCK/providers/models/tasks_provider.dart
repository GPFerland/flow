import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/base_models_provider.dart';
import 'package:flow/src/utils/firestore.dart';
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
    createItem(
      task,
      //context,
    );
  }

  void updateTask(
    Task task,
    BuildContext context,
  ) async {
    updateItem(
      task,
      //context,
    );
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

  Task? getTaskFromId(String id) {
    return state.firstWhereOrNull((task) => task.id == id);
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
