import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/base_models_provider.dart';
import 'package:flow/src/utils/error.dart';
import 'package:flow/src/utils/firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class TaskInstancesNotifier extends BaseModelNotifier<TaskInstance> {
  TaskInstancesNotifier() : super();

  @override
  CollectionReference<TaskInstance> getCollectionRef() {
    return getTaskInstanceCollectionRef();
  }

  Future<void> getTaskInstances() async {
    state = await getItems();
  }

  Future<void> createTaskInstance(
    TaskInstance taskInstance,
    //BuildContext context,
  ) async {
    await createItem(
      taskInstance,
      //context,
    );
  }

  void createTaskInstances(
    List<TaskInstance> taskInstances,
    BuildContext context,
  ) async {
    createItems(taskInstances, context);
  }

  void updateTaskInstance(
    TaskInstance taskInstance,
    BuildContext context,
  ) async {
    updateItem(
      taskInstance,
      //context,
    );
  }

  void updateTaskInstances(
    List<TaskInstance> taskInstances,
    BuildContext context,
  ) async {
    updateItems(taskInstances, context);
  }

  void deleteTaskInstance(
    TaskInstance taskInstance,
    BuildContext context,
  ) async {
    deleteItem(taskInstance, context);
  }

  void deleteTaskInstances(String taskId, BuildContext context) async {
    final taskInstanceCollectionRef = getTaskInstanceCollectionRef();
    final taskInstanceBatch = FirebaseFirestore.instance.batch();

    for (TaskInstance taskInstance in state) {
      if (taskInstance.taskId == taskId) {
        final taskInstanceDocumentRef =
            taskInstanceCollectionRef.doc(taskInstance.id);
        taskInstanceBatch.delete(taskInstanceDocumentRef);
      }
    }

    taskInstanceBatch.commit().onError(
      (error, stackTrace) {
        // Consider retry logic or revert state change
        displayErrorMessageInSnackBar(
          context: context,
          errorMessage: error.toString(),
        );
      },
    );
  }

  TaskInstance? getTaskInstance(String taskId, DateTime date) {
    for (final taskInstance in state) {
      //todo - isDisplayed is not the right name for this check
      if (taskInstance.taskId == taskId && taskInstance.isDisplayed(date)) {
        return taskInstance;
      }
    }

    return null;
  }

  TaskInstance? getTaskInstanceById(String id) {
    for (final taskInstance in state) {
      if (taskInstance.id == id) {
        return taskInstance;
      }
    }

    return null;
  }
}

final taskInstancesProvider =
    StateNotifierProvider<TaskInstancesNotifier, List<TaskInstance>>(
  (ref) {
    return TaskInstancesNotifier();
  },
);
