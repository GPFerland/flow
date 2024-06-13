import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flow/src/features/tasks/domain/task.dart';

class Tasks {
  Tasks({required this.tasksList});

  final List<Task> tasksList;

  @override
  String toString() => 'Tasks(tasksList: $tasksList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tasks && listEquals(other.tasksList, tasksList);
  }

  @override
  int get hashCode => tasksList.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'tasks': tasksList.map((x) => x.toMap()).toList(),
    };
  }

  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks(
      tasksList: List<Task>.from(map['tasks']?.map((x) => Task.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Tasks.fromJson(String source) => Tasks.fromMap(json.decode(source));
}
