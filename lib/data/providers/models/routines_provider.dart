import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/data/models/routine.dart';
import 'package:flow/data/providers/models/base_models_provider.dart';
import 'package:flow/utils/firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class RoutinesNotifier extends BaseModelNotifier<Routine> {
  RoutinesNotifier() : super();

  @override
  CollectionReference<Routine> getCollectionRef() {
    return getRoutineCollectionRef();
  }

  Future<void> getRoutines() async {
    state = await getItems()
      ..sort(
        (a, b) => a.priority!.compareTo(b.priority!),
      );
  }

  void createRoutine(
    Routine routine,
    BuildContext context,
  ) async {
    createItem(routine, context);
  }

  void updateRoutine(
    Routine routine,
    BuildContext context,
  ) async {
    updateItem(routine, context);
  }

  void updateRoutines(
    List<Routine> routines,
    BuildContext context,
  ) async {
    updateItems(routines, context);
  }

  void deleteRoutine(
    Routine routine,
    BuildContext context,
  ) async {
    deleteItem(routine, context);
  }

  Routine? getRoutineFromId(String id) {
    Routine? matchingRoutine = state.firstWhere((routine) => routine.id == id);

    return matchingRoutine;
  }

  String getRoutineTitleFromId(String id) {
    Routine? matchingRoutine = state.firstWhere((routine) => routine.id == id);

    return matchingRoutine.title!;
  }

  Color? getRoutineColorFromId(String id) {
    Routine? matchingRoutine = state.firstWhere((routine) => routine.id == id);

    return matchingRoutine.color;
  }

  void toggleRoutineExpanded(Routine routine, BuildContext context) {
    routine.isExpanded =
        routine.isExpanded != null ? !routine.isExpanded! : false;

    updateItem(routine, context);
  }
}

final routinesProvider = StateNotifierProvider<RoutinesNotifier, List<Routine>>(
  (ref) {
    return RoutinesNotifier();
  },
);
