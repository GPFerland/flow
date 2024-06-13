import 'dart:convert';

/// * The task identifier is an important concept and can have its own type.
typedef TaskInstanceId = String;

class TaskInstance {
  TaskInstance({
    required this.id,
    required this.taskId,
    required this.taskPriority,
    this.routineId,
    this.completed = false,
    this.completedDate,
    this.skipped = false,
    this.skippedDate,
    required this.initialDate,
    this.rescheduledDate,
  });

  final TaskInstanceId id;
  final String taskId;
  final int taskPriority;
  final String? routineId;
  final bool completed;
  final DateTime? completedDate;
  final bool skipped;
  final DateTime? skippedDate;
  final DateTime initialDate;
  final DateTime? rescheduledDate;

  @override
  String toString() {
    return 'TaskInstance(id: $id, taskId: $taskId, taskPriority: $taskPriority, routineId: $routineId, completed: $completed, completedDate: $completedDate, skipped: $skipped, skippedDate: $skippedDate, initialDate: $initialDate, rescheduledDate: $rescheduledDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskInstance &&
        other.id == id &&
        other.taskId == taskId &&
        other.taskPriority == taskPriority &&
        other.routineId == routineId &&
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
        routineId.hashCode ^
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
      'routineId': routineId,
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
      taskId: map['taskId'] ?? '',
      taskPriority: map['taskPriority']?.toInt() ?? 0,
      routineId: map['routineId'],
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
}
