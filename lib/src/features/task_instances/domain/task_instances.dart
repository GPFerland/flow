import 'dart:convert';

import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flutter/foundation.dart';

class TaskInstances {
  TaskInstances({required this.taskInstancesList});

  final List<TaskInstance> taskInstancesList;

  @override
  String toString() => 'TaskInstances(taskInstancesList: $taskInstancesList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskInstances &&
        listEquals(other.taskInstancesList, taskInstancesList);
  }

  @override
  int get hashCode => taskInstancesList.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'taskInstances': taskInstancesList.map((x) => x.toMap()).toList(),
    };
  }

  factory TaskInstances.fromMap(Map<String, dynamic> map) {
    return TaskInstances(
      taskInstancesList: List<TaskInstance>.from(
          map['taskInstances']?.map((x) => TaskInstance.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskInstances.fromJson(String source) =>
      TaskInstances.fromMap(json.decode(source));
}
