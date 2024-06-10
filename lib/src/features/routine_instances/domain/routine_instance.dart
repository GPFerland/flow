import 'package:flow/src/features/task_instances/domain/task_instance.dart';

class RoutineInstance {
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
}
