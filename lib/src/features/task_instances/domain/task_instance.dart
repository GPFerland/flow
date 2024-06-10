import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/src/utils/base_model.dart';

class TaskInstance extends BaseModel {
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

  factory TaskInstance.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    if (data == null) {
      //todo - should probably raise an error here instead of returning a faker
      return TaskInstance(
        taskId: 'fake',
        taskPriority: 0,
        initialDate: DateTime.now(),
      );
    }

    TaskInstance taskInstance = TaskInstance(
      taskId: data['taskId'],
      taskPriority: data['taskPriority'],
      routineId: data['routineId'],
      completed: data['completed'],
      completedDate: data['completedDate']?.toDate(),
      skipped: data['skipped'],
      skippedDate: data['skippedDate']?.toDate(),
      initialDate: data['initialDate'].toDate(),
      rescheduledDate: data['rescheduledDate']?.toDate(),
    );

    taskInstance.setId(snapshot.id);

    return taskInstance;
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'taskId': taskId,
      'taskPriority': taskPriority,
      'routineId': routineId,
      'completed': completed,
      'completedDate': completedDate,
      'skipped': skipped,
      'skippedDate': skippedDate,
      'initialDate': initialDate,
      'rescheduledDate': rescheduledDate,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskInstance &&
        other.id == id &&
        other.taskId == taskId &&
        other.initialDate == initialDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ taskId.hashCode ^ initialDate.hashCode;
  }

  bool isDisplayed(DateTime date) {
    if (completedDate != null && completedDate == date) {
      return true;
    }

    if (rescheduledDate == null && initialDate == date) {
      return true;
    } else if (rescheduledDate != null && rescheduledDate == date) {
      return true;
    }

    if (skippedDate == date) {
      return true;
    }

    return false;
  }

  void toggleCompleted() {
    completed = !completed;
  }
}
