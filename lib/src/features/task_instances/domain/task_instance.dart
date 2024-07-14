import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:flow/src/features/tasks/domain/task.dart';

/// * The task instance identifier is an important concept and can have its own type.
typedef TaskInstanceId = String;

class TaskInstance {
  TaskInstance({
    required this.id,
    required this.taskId,
    required this.taskPriority,
    required this.untilCompleted,
    this.nextInstanceOn,
    this.completed = false,
    this.completedDate,
    this.skipped = false,
    this.skippedDate,
    required this.initialDate,
    this.rescheduledDate,
  });

  final TaskInstanceId id;
  final TaskId taskId;
  final int taskPriority;
  final bool untilCompleted;
  final DateTime? nextInstanceOn;
  final bool completed;
  final DateTime? completedDate;
  final bool skipped;
  final DateTime? skippedDate;
  final DateTime initialDate;
  final DateTime? rescheduledDate;

  @override
  String toString() {
    return 'TaskInstance(id: $id, taskId: $taskId, taskPriority: $taskPriority, untilCompleted: $untilCompleted, nextInstanceOn: $nextInstanceOn, completed: $completed, completedDate: $completedDate, skipped: $skipped, skippedDate: $skippedDate, initialDate: $initialDate, rescheduledDate: $rescheduledDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskInstance &&
        other.id == id &&
        other.taskId == taskId &&
        other.taskPriority == taskPriority &&
        other.untilCompleted == untilCompleted &&
        other.nextInstanceOn == nextInstanceOn &&
        other.completed == completed &&
        other.completedDate == completedDate &&
        other.skipped == skipped &&
        other.skippedDate == skippedDate &&
        other.initialDate == initialDate &&
        other.rescheduledDate == rescheduledDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        taskId.hashCode ^
        taskPriority.hashCode ^
        untilCompleted.hashCode ^
        nextInstanceOn.hashCode ^
        completed.hashCode ^
        completedDate.hashCode ^
        skipped.hashCode ^
        skippedDate.hashCode ^
        initialDate.hashCode ^
        rescheduledDate.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'taskPriority': taskPriority,
      'untilCompleted': untilCompleted,
      'nextInstanceOn': nextInstanceOn?.millisecondsSinceEpoch,
      'completed': completed,
      'completedDate': completedDate?.millisecondsSinceEpoch,
      'skipped': skipped,
      'skippedDate': skippedDate?.millisecondsSinceEpoch,
      'initialDate': initialDate.millisecondsSinceEpoch,
      'rescheduledDate': rescheduledDate?.millisecondsSinceEpoch,
    };
  }

  factory TaskInstance.fromMap(Map<String, dynamic> map) {
    return TaskInstance(
      id: map['id'],
      taskId: map['taskId'],
      taskPriority: map['taskPriority']?.toInt() ?? 0,
      untilCompleted: map['untilCompleted'] ?? false,
      nextInstanceOn: map['nextInstanceOn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['nextInstanceOn'])
          : null,
      completed: map['completed'] ?? false,
      completedDate: map['completedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completedDate'])
          : null,
      skipped: map['skipped'] ?? false,
      skippedDate: map['skippedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['skippedDate'])
          : null,
      initialDate: DateTime.fromMillisecondsSinceEpoch(map['initialDate']),
      rescheduledDate: map['rescheduledDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['rescheduledDate'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskInstance.fromJson(String source) =>
      TaskInstance.fromMap(json.decode(source));

  TaskInstance copyWith({
    TaskInstanceId? id,
    TaskId? taskId,
    int? taskPriority,
    bool? untilCompleted,
    ValueGetter<DateTime?>? nextInstanceOn,
    bool? completed,
    ValueGetter<DateTime?>? completedDate,
    bool? skipped,
    ValueGetter<DateTime?>? skippedDate,
    DateTime? initialDate,
    ValueGetter<DateTime?>? rescheduledDate,
  }) {
    return TaskInstance(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      taskPriority: taskPriority ?? this.taskPriority,
      untilCompleted: untilCompleted ?? this.untilCompleted,
      nextInstanceOn:
          nextInstanceOn != null ? nextInstanceOn() : this.nextInstanceOn,
      completed: completed ?? this.completed,
      completedDate:
          completedDate != null ? completedDate() : this.completedDate,
      skipped: skipped ?? this.skipped,
      skippedDate: skippedDate != null ? skippedDate() : this.skippedDate,
      initialDate: initialDate ?? this.initialDate,
      rescheduledDate:
          rescheduledDate != null ? rescheduledDate() : this.rescheduledDate,
    );
  }
}
