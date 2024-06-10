import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/src/features/routine_instances/domain/routine_instance.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/base_models_provider.dart';
import 'package:flow/src/utils/firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class RoutineInstancesNotifier extends BaseModelNotifier<RoutineInstance> {
  RoutineInstancesNotifier() : super();

  @override
  CollectionReference<RoutineInstance> getCollectionRef() {
    return getRoutineInstanceCollectionRef();
  }

  Future<void> getRoutineInstances() async {
    state = await getItems();
  }

  Future<void> createRoutineInstance(
    RoutineInstance routine,
    //BuildContext context,
  ) async {
    await createItem(
      routine,
      //context,
    );
  }

  Future<void> updateRoutineInstance(
    RoutineInstance routine,
    //BuildContext context,
  ) async {
    await updateItem(
      routine,
      //context,
    );
  }

  void updateRoutineInstances(
    List<RoutineInstance> routineInstances,
    BuildContext context,
  ) async {
    updateItems(routineInstances, context);
  }

  void deleteRoutineInstance(
    RoutineInstance routine,
    BuildContext context,
  ) async {
    deleteItem(routine, context);
  }

  RoutineInstance? getRoutineInstance(String routineId, DateTime date) {
    for (final routineInstance in state) {
      if (routineInstance.routineId == routineId &&
          routineInstance.date == date) {
        return routineInstance;
      }
    }

    return null;
  }
}

final routineInstancesProvider =
    StateNotifierProvider<RoutineInstancesNotifier, List<RoutineInstance>>(
  (ref) {
    return RoutineInstancesNotifier();
  },
);
