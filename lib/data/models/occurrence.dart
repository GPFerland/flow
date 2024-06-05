import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/data/models/base_model.dart';

class Occurrence extends BaseModel {
  Occurrence({
    this.taskId,
    this.completed,
    this.originalDate,
    this.rescheduledDate,
    this.completedDate,
    this.skippedDate,
    this.skipped,
  });

  String? taskId;
  bool? completed;
  DateTime? originalDate;
  DateTime? rescheduledDate;
  DateTime? completedDate;
  DateTime? skippedDate;
  bool? skipped;

  factory Occurrence.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    Occurrence occurrence = Occurrence(
      taskId: data!['taskId'],
      completed: data['completed'],
      originalDate: data['originalDate'].toDate(),
      rescheduledDate: data['rescheduledDate']?.toDate(),
      completedDate: data['completedDate']?.toDate(),
      skippedDate: data['skippedDate']?.toDate(),
      skipped: data['skipped'],
    );

    occurrence.setId(snapshot.id);

    return occurrence;
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'taskId': taskId,
      'completed': completed,
      'originalDate': originalDate,
      'rescheduledDate': rescheduledDate,
      'completedDate': completedDate,
      'skippedDate': skippedDate,
      'skipped': skipped,
      'priority': priority,
    };
  }

  bool isRequired(DateTime date) {
    bool isRequired = false;

    if (skipped ?? false) {
      return false;
    }

    if (rescheduledDate == null) {
      if (originalDate == date) {
        isRequired = true;
      }
    } else {
      if (rescheduledDate == date) {
        isRequired = true;
      }
    }

    return isRequired;
  }
}

//todo - is this the best place for this to live?
Occurrence? getMatchingOccurrence(
  List<Occurrence> occurrences,
  DateTime date,
) {
  for (Occurrence occurrence in occurrences) {
    if (occurrence.rescheduledDate == null) {
      if (occurrence.originalDate == date) {
        return occurrence;
      }
    } else {
      if (occurrence.rescheduledDate == date ||
          occurrence.originalDate == date) {
        return occurrence;
      }
    }
    if (occurrence.completedDate != null && occurrence.completedDate == date) {
      return occurrence;
    }
    if (occurrence.skippedDate != null && occurrence.skippedDate == date) {
      return occurrence;
    }
  }
  return null;
}
