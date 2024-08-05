import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:flow/src/features/tasks/domain/task.dart';

// * The task instance identifier is an important concept and can have its own type.
typedef TaskInstanceId = String;

class TaskInstance {
  TaskInstance({
    required this.id,
    required this.taskId,
    required this.taskPriority,
    required this.untilAddressed,
    this.completed = false,
    this.completedDate,
    this.skipped = false,
    this.skippedDate,
    required this.scheduledDate,
    this.rescheduledDate,
    this.nextScheduledDate,
  });

  final TaskInstanceId id;
  final TaskId taskId;
  final int taskPriority;
  final bool untilAddressed;
  final bool completed;
  final DateTime? completedDate;
  final bool skipped;
  final DateTime? skippedDate;
  final DateTime scheduledDate;
  final DateTime? rescheduledDate;
  final DateTime? nextScheduledDate;

  @override
  String toString() {
    return 'TaskInstance(id: $id, taskId: $taskId, taskPriority: $taskPriority, untilAddressed: $untilAddressed, completed: $completed, completedDate: $completedDate, skipped: $skipped, skippedDate: $skippedDate, scheduledDate: $scheduledDate, rescheduledDate: $rescheduledDate, nextScheduledDate: $nextScheduledDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskInstance &&
        other.id == id &&
        other.taskId == taskId &&
        other.taskPriority == taskPriority &&
        other.untilAddressed == untilAddressed &&
        other.completed == completed &&
        other.completedDate == completedDate &&
        other.skipped == skipped &&
        other.skippedDate == skippedDate &&
        other.scheduledDate == scheduledDate &&
        other.rescheduledDate == rescheduledDate &&
        other.nextScheduledDate == nextScheduledDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        taskId.hashCode ^
        taskPriority.hashCode ^
        untilAddressed.hashCode ^
        completed.hashCode ^
        completedDate.hashCode ^
        skipped.hashCode ^
        skippedDate.hashCode ^
        scheduledDate.hashCode ^
        rescheduledDate.hashCode ^
        nextScheduledDate.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'taskPriority': taskPriority,
      'untilAddressed': untilAddressed,
      'completed': completed,
      'completedDate': completedDate?.millisecondsSinceEpoch,
      'skipped': skipped,
      'skippedDate': skippedDate?.millisecondsSinceEpoch,
      'scheduledDate': scheduledDate.millisecondsSinceEpoch,
      'rescheduledDate': rescheduledDate?.millisecondsSinceEpoch,
      'nextScheduledDate': nextScheduledDate?.millisecondsSinceEpoch,
    };
  }

  factory TaskInstance.fromMap(Map<String, dynamic> map) {
    return TaskInstance(
      id: map['id'],
      taskId: map['taskId'],
      taskPriority: map['taskPriority']?.toInt() ?? 0,
      untilAddressed: map['untilAddressed'] ?? false,
      completed: map['completed'] ?? false,
      completedDate: map['completedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completedDate'])
          : null,
      skipped: map['skipped'] ?? false,
      skippedDate: map['skippedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['skippedDate'])
          : null,
      scheduledDate: DateTime.fromMillisecondsSinceEpoch(map['scheduledDate']),
      rescheduledDate: map['rescheduledDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['rescheduledDate'])
          : null,
      nextScheduledDate: map['nextScheduledDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['nextScheduledDate'])
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
    bool? untilAddressed,
    bool? completed,
    ValueGetter<DateTime?>? completedDate,
    bool? skipped,
    ValueGetter<DateTime?>? skippedDate,
    DateTime? scheduledDate,
    ValueGetter<DateTime?>? rescheduledDate,
    ValueGetter<DateTime?>? nextScheduledDate,
  }) {
    return TaskInstance(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      taskPriority: taskPriority ?? this.taskPriority,
      untilAddressed: untilAddressed ?? this.untilAddressed,
      completed: completed ?? this.completed,
      completedDate:
          completedDate != null ? completedDate() : this.completedDate,
      skipped: skipped ?? this.skipped,
      skippedDate: skippedDate != null ? skippedDate() : this.skippedDate,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      rescheduledDate:
          rescheduledDate != null ? rescheduledDate() : this.rescheduledDate,
      nextScheduledDate: nextScheduledDate != null
          ? nextScheduledDate()
          : this.nextScheduledDate,
    );
  }
}
