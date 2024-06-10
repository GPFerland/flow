class TaskInstance {
  TaskInstance({
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

  String taskId;
  int taskPriority;
  String? routineId;
  bool completed;
  DateTime? completedDate;
  bool skipped;
  DateTime? skippedDate;
  DateTime initialDate;
  DateTime? rescheduledDate;
}
