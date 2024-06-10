import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/src/utils/base_model.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class Task extends BaseModel {
  Task({
    this.title,
    this.icon,
    this.color,
    this.frequency,
    this.description,
    this.showUntilCompleted,
    this.routineId,
    this.initialDate,
    this.selectedDate,
    this.selectedWeekdays,
    this.selectedMonthDays,
  });

  String? title;
  IconData? icon;
  Color? color;
  Frequency? frequency;
  String? description;
  bool? showUntilCompleted;
  String? routineId;
  DateTime? initialDate;
  DateTime? selectedDate;
  Map<String, bool>? selectedWeekdays;
  List<Map<String, dynamic>>? selectedMonthDays;

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
      showUntilCompleted: data['showUntilCompleted'] ?? true,
      routineId: data['routineId'],
      initialDate: data['initialDate'],
      selectedDate: data['selectedDate'].toDate(),
      selectedWeekdays: data['selectedWeekDays'].cast<String, bool>(),
      selectedMonthDays: data['selectedMonthDays'] != null
          ? data['selectedMonthDays'].cast<Map<String, dynamic>>()
          : List.empty(growable: true),
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
      'showUntilCompleted': showUntilCompleted ?? true,
      'routineId': routineId,
      'selectedDate': selectedDate,
      'selectedWeekDays': selectedWeekdays,
      'selectedMonthDays': selectedMonthDays,
      'priority': priority,
    };
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

  bool _isOnceTaskScheduled(DateTime date) {
    if (date == selectedDate!) {
      return true;
    } else {
      return false;
    }
  }

  bool _isWeeklyTaskScheduled(DateTime date) {
    if (selectedWeekdays == null) {
      return false;
    }

    DateTime? mostRecentScheduledWeeklyDate = getPreviousScheduledDate(date);

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

  bool _isMonthlyTaskScheduled(DateTime date) {
    if (selectedMonthDays == null || selectedMonthDays!.isEmpty) {
      return false;
    }

    DateTime? mostRecentScheduledMonthlyDate = getPreviousScheduledDate(date);

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

  DateTime? getPreviousScheduledDate(DateTime date) {
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

  DateTime? getNextScheduledDate(DateTime date) {
    if (frequency == Frequency.weekly) {
      return _getNextWeeklyScheduledDate(date);
    } else if (frequency == Frequency.monthly) {
      return _getNextMonthlyScheduledDate(date);
    }
    return null;
  }

  DateTime? _getNextWeeklyScheduledDate(DateTime date) {
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

  DateTime? _getNextMonthlyScheduledDate(DateTime date) {
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

  void removeRoutineFromTask() {
    routineId = null;
  }
}
