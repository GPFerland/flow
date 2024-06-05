import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/data/models/base_model.dart';
import 'package:flow/data/models/occurrence.dart';
import 'package:flow/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class Task extends BaseModel {
  Task({
    this.title,
    this.icon,
    this.color,
    this.frequency,
    this.description,
    this.routineId,
    this.selectedDate,
    this.selectedWeekdays,
    this.selectedMonthDays,
    this.occurrences,
    this.showUntilCompleted,
  });

  String? title;
  IconData? icon;
  Color? color;
  Frequency? frequency;
  String? description;
  String? routineId;
  DateTime? selectedDate;
  Map<String, bool>? selectedWeekdays;
  List<Map<String, dynamic>>? selectedMonthDays;
  List<Occurrence>? occurrences;
  bool? showUntilCompleted;

  factory Task.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    Task task = Task(
      title: data!['title'],
      icon: deserializeIcon(data['icon'], iconPack: IconPack.allMaterial),
      color: Color(data['color']),
      frequency: reverseFrequencyMap[data['frequency']]!,
      description: data['description'],
      routineId: data['routineId'],
      selectedDate: data['selectedDate'].toDate(),
      selectedWeekdays: data['selectedWeekDays'].cast<String, bool>(),
      selectedMonthDays: data['selectedMonthDays'] != null
          ? data['selectedMonthDays'].cast<Map<String, dynamic>>()
          : List.empty(growable: true),
      occurrences: [],
      showUntilCompleted: data['showUntilCompleted'] ?? true,
    );

    task.setId(snapshot.id);
    task.setPriority(data['priority']);

    return task;
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      if (icon != null)
        'icon': serializeIcon(
          icon!,
          iconPack: IconPack.allMaterial,
        ),
      'color': color!.value,
      'frequency': frequencyMap[frequency],
      if (description != null) 'description': description,
      'routineId': routineId,
      'selectedDate': selectedDate,
      'selectedWeekDays': selectedWeekdays,
      'selectedMonthDays': selectedMonthDays,
      'showUntilCompleted': showUntilCompleted ?? true,
      'priority': priority,
    };
  }

  void addOccurrence(Occurrence occurrence) {
    occurrences ??= List<Occurrence>.empty(growable: true);
    if (!occurrences!.contains(occurrence)) {
      occurrences!.add(occurrence);
    }
  }

  String get frequencyText {
    switch (frequency) {
      case Frequency.once:
        return getFormattedDateString(selectedDate!);
      case Frequency.weekly:
        return _getWeeklyFrequencyText();
      case Frequency.monthly:
        return _getMonthlyFrequencyText();
      default:
        return getFormattedDateString(selectedDate!);
    }
  }

  String _getWeeklyFrequencyText() {
    List<String> selectedWeekDaysList = selectedWeekdays?.keys
            .where((day) => selectedWeekdays![day]!)
            .toList() ??
        [];
    if (selectedWeekDaysList.isEmpty) {
      return 'No days selected';
    } else {
      if (selectedWeekDaysList.length == shorthandWeekdays.length) {
        return 'Everyday';
      } else if (selectedWeekDaysList.length == 2) {
        return sortDaysList(selectedWeekDaysList).join(' & ');
      }
      return sortDaysList(selectedWeekDaysList).join(', ');
    }
  }

  String _getMonthlyFrequencyText() {
    if (selectedMonthDays == null || selectedMonthDays!.isEmpty) {
      return 'No Days Selected';
    } else if (selectedMonthDays!.length == 1) {
      return '${selectedMonthDays![0]['when']} ${selectedMonthDays![0]['whatDay']} of the Month';
    } else if (selectedMonthDays!.length >= 2) {
      return 'Multiple Days a Month';
    }
    return 'No Days Selected';
  }

  bool isComplete(DateTime date) {
    if (occurrences == null) {
      return false;
    }

    Occurrence? matchingOccurrence = getMatchingOccurrence(
      occurrences!,
      date,
    );

    if (matchingOccurrence == null) {
      return false;
    } else {
      return matchingOccurrence.completed!;
    }
  }

  bool isScheduled(DateTime date) {
    if (frequency == Frequency.once) {
      return _isOnceTaskScheduled(date);
    } else if (frequency == Frequency.weekly) {
      return _isWeeklyTaskScheduled(date);
    } else if (frequency == Frequency.monthly) {
      return _isMonthlyTaskScheduled(date);
    }
    return true;
  }

  bool isRescheduled(DateTime date) {
    if (frequency == Frequency.once) {
      return _isOnceTaskRescheduled(date);
    } else if (frequency == Frequency.weekly) {
      return _isWeeklyTaskRescheduled(date);
    } else if (frequency == Frequency.monthly) {
      return _isMonthlyTaskRescheduled(date);
    }
    return true;
  }

  bool isOverdue(DateTime date) {
    if (!showUntilCompleted!) {
      return false;
    }
    if (date != getDateNoTime(DateTime.now())) {
      return false;
    }

    if (frequency == Frequency.once) {
      return _isOnceTaskOverdue(date);
    } else if (frequency == Frequency.weekly) {
      return _isWeeklyTaskOverdue(date);
    } else if (frequency == Frequency.monthly) {
      return _isMonthlyTaskOverdue(date);
    }
    return true;
  }

  bool _isOnceTaskScheduled(DateTime date) {
    if (date == selectedDate!) {
      return true;
    } else {
      return false;
    }
  }

  bool _isOnceTaskRescheduled(DateTime date) {
    if (occurrences == null) {
      return false;
    }

    Occurrence? matchingOccurrence = getMatchingOccurrence(
      occurrences!,
      selectedDate!,
    );
    if (matchingOccurrence == null) {
      return false;
    } else if (matchingOccurrence.rescheduledDate == date) {
      return true;
    }
    return false;
  }

  bool _isOnceTaskOverdue(DateTime date) {
    if (date.isBefore(selectedDate!)) {
      return false;
    }

    if (occurrences == null) {
      return true;
    }

    Occurrence? matchingOccurrence = getMatchingOccurrence(
      occurrences!,
      selectedDate!,
    );
    if (matchingOccurrence == null) {
      return true;
    } else if (matchingOccurrence.completedDate == date) {
      return true;
    } else if (matchingOccurrence.completed! || matchingOccurrence.skipped!) {
      return false;
    } else if (matchingOccurrence.rescheduledDate != null &&
        matchingOccurrence.rescheduledDate != date) {
      return false;
    }
    return true;
  }

  bool _isWeeklyTaskScheduled(DateTime date) {
    if (selectedWeekdays == null) {
      return false;
    }

    DateTime? mostRecentScheduledWeeklyDate = getMostRecentScheduledDate(date);

    if (mostRecentScheduledWeeklyDate != null) {
      if (mostRecentScheduledWeeklyDate == date) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool _isWeeklyTaskRescheduled(DateTime date) {
    if (selectedWeekdays == null) {
      return false;
    }

    Occurrence? matchingOccurrence = getMatchingOccurrence(occurrences!, date);
    if (matchingOccurrence == null) {
      return false;
    } else if (matchingOccurrence.rescheduledDate == date) {
      return true;
    }
    return false;
  }

  bool _isWeeklyTaskOverdue(DateTime date) {
    if (selectedWeekdays == null) {
      return false;
    }

    DateTime? mostRecentScheduledWeeklyDate = getMostRecentScheduledDate(date);

    if (mostRecentScheduledWeeklyDate != null) {
      Occurrence? matchingOccurrence = getMatchingOccurrence(
        occurrences!,
        mostRecentScheduledWeeklyDate,
      );
      if (matchingOccurrence == null) {
        return true;
      } else if (matchingOccurrence.completedDate == date) {
        return true;
      } else if (matchingOccurrence.completed! || matchingOccurrence.skipped!) {
        return false;
      } else if (matchingOccurrence.rescheduledDate != null &&
          matchingOccurrence.rescheduledDate != date) {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  bool _isMonthlyTaskScheduled(DateTime date) {
    if (selectedMonthDays == null || selectedMonthDays!.isEmpty) {
      return false;
    }

    DateTime? mostRecentScheduledMonthlyDate = getMostRecentScheduledDate(date);

    if (mostRecentScheduledMonthlyDate != null) {
      if (mostRecentScheduledMonthlyDate == date) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool _isMonthlyTaskRescheduled(DateTime date) {
    if (selectedMonthDays == null || selectedMonthDays!.isEmpty) {
      return false;
    }

    Occurrence? matchingOccurrence = getMatchingOccurrence(occurrences!, date);
    if (matchingOccurrence == null) {
      return false;
    } else if (matchingOccurrence.rescheduledDate == date) {
      return true;
    }
    return false;
  }

  bool _isMonthlyTaskOverdue(DateTime date) {
    if (selectedMonthDays == null || selectedMonthDays!.isEmpty) {
      return false;
    }

    DateTime? mostRecentScheduledMonthlyDate = getMostRecentScheduledDate(date);

    if (mostRecentScheduledMonthlyDate != null) {
      Occurrence? matchingOccurrence = getMatchingOccurrence(
        occurrences!,
        mostRecentScheduledMonthlyDate,
      );
      if (matchingOccurrence == null) {
        return true;
      } else if (matchingOccurrence.completedDate == date) {
        return true;
      } else if (matchingOccurrence.completed! || matchingOccurrence.skipped!) {
        return false;
      } else if (matchingOccurrence.rescheduledDate != null &&
          matchingOccurrence.rescheduledDate != date) {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  DateTime? getMostRecentScheduledDate(DateTime date) {
    if (frequency == Frequency.once) {
      return selectedDate;
    } else if (frequency == Frequency.weekly) {
      return _getMostRecentScheduledWeeklyDate(date);
    } else if (frequency == Frequency.monthly) {
      return _getMostRecentScheduledMonthlyDate(date);
    }
    return null;
  }

  DateTime? _getMostRecentScheduledWeeklyDate(DateTime date) {
    DateTime? mostRecentScheduledWeeklyDate;

    for (MapEntry<String, bool> weekday in selectedWeekdays!.entries) {
      DateTime tempDate = DateTime(date.year, date.month, date.day);
      while (tempDate.weekday != date.weekday || tempDate.day == date.day) {
        if (weekday.value && (weekday.key == getAbbreviatedWeekday(tempDate))) {
          mostRecentScheduledWeeklyDate ??= tempDate;
          if (mostRecentScheduledWeeklyDate.isBefore(tempDate)) {
            mostRecentScheduledWeeklyDate = tempDate;
          }
        }
        tempDate = tempDate.subtract(
          const Duration(days: 1),
        );
      }
    }

    return mostRecentScheduledWeeklyDate;
  }

  DateTime? _getMostRecentScheduledMonthlyDate(DateTime date) {
    DateTime? mostRecentScheduledMonthlyDate;

    for (Map<String, dynamic> selectedMonthDay in selectedMonthDays!) {
      DateTime? tempDate;
      int occurrenceNum = monthlyOrdinalsToIntsMap[selectedMonthDay['when']]!;
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
      DateTime lastDayOfLastMonth = DateTime(date.year, date.month, 0);

      if (selectedMonthDay['whatDay'] == 'Day') {
        if (selectedMonthDay['when'] == 'Last') {
          tempDate = _chooseLastDayOfMonth(
            date,
            lastDayOfMonth,
            lastDayOfLastMonth,
          );
        } else {
          firstDayOfMonth = firstDayOfMonth.add(
            Duration(days: occurrenceNum),
          );
          tempDate = firstDayOfMonth;
        }
      } else {
        if (selectedMonthDay['when'] == 'Last') {
          int dayOfWeekIndex = weekdayIndices[selectedMonthDay['whatDay']]!;
          lastDayOfMonth = _subtractTillWeekday(
            lastDayOfMonth,
            dayOfWeekIndex,
          );
          lastDayOfLastMonth = _subtractTillWeekday(
            lastDayOfLastMonth,
            dayOfWeekIndex,
          );
          tempDate = _chooseLastDayOfMonth(
            date,
            lastDayOfMonth,
            lastDayOfLastMonth,
          );
        } else {
          int dayOfWeekIndex = weekdayIndices[selectedMonthDay['whatDay']]!;
          firstDayOfMonth = _addTillWeekday(firstDayOfMonth, dayOfWeekIndex);

          int occurrenceCount = 0;
          for (DateTime loopDate = firstDayOfMonth;
              loopDate.month == date.month;
              loopDate = loopDate.add(const Duration(days: 7))) {
            if (occurrenceCount == occurrenceNum) {
              tempDate = loopDate;
            }
            occurrenceCount++;
          }
        }
      }
      mostRecentScheduledMonthlyDate ??= tempDate;
      if (tempDate != null &&
          tempDate.isAfter(mostRecentScheduledMonthlyDate!)) {
        mostRecentScheduledMonthlyDate = tempDate;
      }
    }
    return mostRecentScheduledMonthlyDate;
  }

  DateTime _addTillWeekday(DateTime date, int dayOfWeekIndex) {
    while (date.weekday != dayOfWeekIndex) {
      date = date.add(
        const Duration(days: 1),
      );
    }
    return date;
  }

  DateTime _subtractTillWeekday(DateTime date, int dayOfWeekIndex) {
    while (date.weekday != dayOfWeekIndex) {
      date = date.subtract(
        const Duration(days: 1),
      );
    }
    return date;
  }

  DateTime _chooseLastDayOfMonth(
    DateTime date,
    DateTime lastDayOfMonth,
    DateTime lastDayOfLastMonth,
  ) {
    if (date.isBefore(lastDayOfMonth)) {
      return lastDayOfLastMonth;
    } else {
      return lastDayOfMonth;
    }
  }

  bool isRequired(DateTime date) {
    if (occurrences != null && occurrences!.isNotEmpty) {
      for (Occurrence taskOccurrence in occurrences!) {
        if (taskOccurrence.isRequired(date)) {
          return true;
        }
      }
    }
    return false;
  }

  DateTime? getNextOccurrence(DateTime date) {
    if (frequency == Frequency.weekly) {
      return _getNextWeeklyOccurrence(date);
    } else if (frequency == Frequency.monthly) {
      return _getNextMonthlyOccurrence(date);
    }
    return null;
  }

  DateTime? _getNextWeeklyOccurrence(DateTime date) {
    if (selectedWeekdays == null) {
      return null;
    }

    DateTime? nextDate;

    for (MapEntry<String, bool> weekDay in selectedWeekdays!.entries) {
      DateTime tempDate = DateTime(date.year, date.month, date.day + 1);
      bool stop = false;

      while (!stop) {
        if (weekDay.value && weekDay.key == getAbbreviatedWeekday(tempDate)) {
          nextDate ??= tempDate;
          if (nextDate.isAfter(tempDate)) {
            nextDate = tempDate;
          }
        }
        if (tempDate.weekday == date.weekday) {
          stop = true;
        }
        tempDate = tempDate.add(
          const Duration(days: 1),
        );
      }
    }

    return nextDate;
  }

  DateTime? _getNextMonthlyOccurrence(DateTime date) {
    if (selectedMonthDays == null || selectedMonthDays!.isEmpty) {
      return null;
    }

    DateTime? nextOccurrence;

    for (Map<String, dynamic> selectedMonthDay in selectedMonthDays!) {
      DateTime? tempDate;

      int occurrenceNum = monthlyOrdinalsToIntsMap[selectedMonthDay['when']]!;
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
      DateTime firstDayOfNextMonth = DateTime(date.year, date.month + 1, 1);
      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
      DateTime lastDayOfNextMonth = DateTime(date.year, date.month + 2, 0);

      if (selectedMonthDay['whatDay'] == 'Day') {
        if (selectedMonthDay['when'] == 'Last') {
          if (date.isBefore(lastDayOfMonth)) {
            tempDate = lastDayOfMonth;
          } else {
            tempDate = lastDayOfNextMonth;
          }
        } else {
          firstDayOfMonth = firstDayOfMonth.add(
            Duration(days: occurrenceNum),
          );
          if (date.isBefore(firstDayOfMonth)) {
            tempDate = firstDayOfMonth;
          } else {
            tempDate = firstDayOfNextMonth.add(
              Duration(days: occurrenceNum),
            );
          }
        }
      } else {
        if (selectedMonthDay['when'] == 'Last') {
          int dayOfWeekIndex = weekdayIndices[selectedMonthDay['whatDay']]!;
          lastDayOfMonth = _subtractTillWeekday(
            lastDayOfMonth,
            dayOfWeekIndex,
          );
          if (date.isBefore(lastDayOfMonth)) {
            tempDate = lastDayOfMonth;
          } else {
            tempDate = _subtractTillWeekday(
              lastDayOfNextMonth,
              dayOfWeekIndex,
            );
          }
        } else {
          int dayOfWeekIndex = weekdayIndices[selectedMonthDay['whatDay']]!;
          firstDayOfMonth = _addTillWeekday(
            firstDayOfMonth,
            dayOfWeekIndex,
          );

          int occurrenceCount = 0;
          int tempMonth = 0;
          for (DateTime loopDate = firstDayOfMonth;
              loopDate.year < date.year + 1;
              loopDate = loopDate.add(const Duration(days: 7))) {
            if (loopDate.month != tempMonth) {
              tempMonth = loopDate.month;
              occurrenceCount = 0;
            }
            if (occurrenceCount == occurrenceNum) {
              if (date.isBefore(loopDate)) {
                tempDate = loopDate;
                break;
              }
            }
            occurrenceCount++;
          }
        }
      }
      if (nextOccurrence == null ||
          (tempDate != null && tempDate.isBefore(nextOccurrence))) {
        nextOccurrence = tempDate;
      }
    }
    return nextOccurrence;
  }

  void reschedule(
    DateTime originalDate,
    DateTime? rescheduledDate,
  ) {
    if (occurrences != null) {
      for (Occurrence taskOccurrence in occurrences!) {
        if (originalDate == taskOccurrence.originalDate ||
            originalDate == taskOccurrence.rescheduledDate) {
          taskOccurrence.rescheduledDate = rescheduledDate;
        }
      }
    }
  }

  void toggleStatus(DateTime date) {
    if (occurrences != null) {
      for (Occurrence taskOccurrence in occurrences!) {
        if (date == taskOccurrence.originalDate ||
            date == taskOccurrence.rescheduledDate) {
          taskOccurrence.completed = !taskOccurrence.completed!;
        }
      }
    }
  }

  void removeRoutineFromTask() {
    routineId = null;
  }
}
