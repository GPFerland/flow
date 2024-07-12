import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flow/src/utils/date.dart';

/// * The task identifier is an important concept and can have its own type.
typedef TaskId = String;

class Task {
  Task({
    required this.id,
    required this.priority,
    required this.createdOn,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.untilCompleted,
    required this.frequency,
    required this.date,
    required this.weekdays,
    required this.monthdays,
  });

  final TaskId id;
  final int priority;
  final DateTime createdOn;
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final bool untilCompleted;
  final Frequency frequency;
  final DateTime date;
  final List<Weekday> weekdays;
  final List<Monthday> monthdays;

  Task copyWith({
    TaskId? id,
    int? priority,
    DateTime? createdOn,
    String? title,
    IconData? icon,
    Color? color,
    String? description,
    bool? untilCompleted,
    Frequency? frequency,
    DateTime? date,
    List<Weekday>? weekdays,
    List<Monthday>? monthdays,
  }) {
    return Task(
      id: id ?? this.id,
      priority: priority ?? this.priority,
      createdOn: createdOn ?? this.createdOn,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      untilCompleted: untilCompleted ?? this.untilCompleted,
      frequency: frequency ?? this.frequency,
      date: date ?? this.date,
      weekdays: weekdays ?? this.weekdays,
      monthdays: monthdays ?? this.monthdays,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'priority': priority,
      'createdOn': createdOn.millisecondsSinceEpoch,
      'title': title,
      'icon': icon.codePoint,
      'color': color.value,
      'description': description,
      'untilCompleted': untilCompleted,
      'frequency': frequency.toMap(),
      'date': date.millisecondsSinceEpoch,
      'weekdays': weekdays.map((x) => x.toMap()).toList(),
      'monthdays': monthdays.map((x) => x.toMap()).toList(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      priority: map['priority']?.toInt() ?? 0,
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
      title: map['title'] ?? '',
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      color: Color(map['color']),
      description: map['description'] ?? '',
      untilCompleted: map['untilCompleted'] ?? false,
      frequency: Frequency.fromMap(map['frequency']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      weekdays:
          List<Weekday>.from(map['weekdays']?.map((x) => Weekday.fromMap(x))),
      monthdays: List<Monthday>.from(
          map['monthdays']?.map((x) => Monthday.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Task(id: $id, priority: $priority, createdOn: $createdOn, title: $title, icon: $icon, color: $color, description: $description, untilCompleted: $untilCompleted, frequency: $frequency, date: $date, weekdays: $weekdays, monthdays: $monthdays)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.id == id &&
        other.priority == priority &&
        other.createdOn == createdOn &&
        other.title == title &&
        other.icon == icon &&
        other.color == color &&
        other.description == description &&
        other.untilCompleted == untilCompleted &&
        other.frequency == frequency &&
        other.date == date &&
        listEquals(other.weekdays, weekdays) &&
        listEquals(other.monthdays, monthdays);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        priority.hashCode ^
        createdOn.hashCode ^
        title.hashCode ^
        icon.hashCode ^
        color.hashCode ^
        description.hashCode ^
        untilCompleted.hashCode ^
        frequency.hashCode ^
        date.hashCode ^
        weekdays.hashCode ^
        monthdays.hashCode;
  }
}
