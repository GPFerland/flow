import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/src/utils/base_model.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';

class RoutineInstance extends BaseModel {
  RoutineInstance({
    required this.routineId,
    required this.date,
    this.isExpanded = false,
    this.taskInstanceIds,
    this.taskInstances,
  });

  String routineId;
  DateTime date;
  bool isExpanded;
  List<String>? taskInstanceIds;
  List<TaskInstance>? taskInstances;

  factory RoutineInstance.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    RoutineInstance routineInstance = RoutineInstance(
      routineId: data!['routineId'],
      date: data['date']?.toDate(),
      isExpanded: data['isExpanded'],
      taskInstanceIds: data['taskInstanceIds'],
    );

    routineInstance.setId(snapshot.id);

    return routineInstance;
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'routineId': routineId,
      'date': date,
      'isExpanded': isExpanded,
      'taskInstanceIds': taskInstanceIds,
    };
  }

  bool get isComplete {
    bool isComplete = true;
    for (TaskInstance taskInstance in taskInstances!) {
      if (!taskInstance.completed) {
        isComplete = false;
      }
    }
    return isComplete;
  }

  void toggleExpanded() {
    isExpanded = !isExpanded;
  }

  void addTaskInstance(TaskInstance taskInstance) {
    taskInstances ??= [];
    taskInstanceIds ??= [];
    if (!taskInstanceIds!.contains(taskInstance.id)) {
      taskInstances!.add(taskInstance);
      taskInstanceIds!.add(taskInstance.id!);
    }
  }

  int getHighestTaskPriority() {
    int tempPriority = 10000;
    if (taskInstanceIds != null && taskInstanceIds!.isNotEmpty) {
      for (TaskInstance taskInstance in taskInstances!) {
        tempPriority = taskInstance.taskPriority < tempPriority
            ? taskInstance.taskPriority
            : tempPriority;
      }
    }
    return tempPriority;
  }

  int getHighestUncompletedTaskPriority() {
    //todo - I dont think this number is good to use
    int tempPriority = 10000;
    if (taskInstanceIds != null && taskInstanceIds!.isNotEmpty) {
      for (TaskInstance taskInstance in taskInstances!) {
        tempPriority =
            taskInstance.taskPriority < tempPriority && !taskInstance.completed
                ? taskInstance.taskPriority
                : tempPriority;
      }
    }
    return tempPriority;
  }
}
