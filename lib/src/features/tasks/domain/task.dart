import 'dart:convert';

import 'package:flow/src/utils/date.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// * The task identifier is an important concept and can have its own type.
typedef TaskId = String;

class Task {
  Task({
    required this.id,
    required this.createdOn,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.showUntilCompleted,
    required this.frequencyType,
    required this.date,
    required this.weekdays,
    required this.monthdays,
  });

  final TaskId id;
  final DateTime createdOn;
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final bool showUntilCompleted;
  final FrequencyType frequencyType;
  final DateTime date;
  final List<Weekday> weekdays;
  final List<Monthday> monthdays;

  @override
  String toString() {
    return 'Task(id: $id, createdOn: $createdOn, title: $title, icon: $icon, color: $color, description: $description, showUntilCompleted: $showUntilCompleted, frequencyType: $frequencyType, date: $date, weekdays: $weekdays, monthdays: $monthdays)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.id == id &&
        other.createdOn == createdOn &&
        other.title == title &&
        other.icon == icon &&
        other.color == color &&
        other.description == description &&
        other.showUntilCompleted == showUntilCompleted &&
        other.frequencyType == frequencyType &&
        other.date == date &&
        listEquals(other.weekdays, weekdays) &&
        listEquals(other.monthdays, monthdays);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdOn.hashCode ^
        title.hashCode ^
        icon.hashCode ^
        color.hashCode ^
        description.hashCode ^
        showUntilCompleted.hashCode ^
        frequencyType.hashCode ^
        date.hashCode ^
        weekdays.hashCode ^
        monthdays.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdOn': createdOn.millisecondsSinceEpoch,
      'title': title,
      'icon': icon.codePoint,
      'color': color.value,
      'description': description,
      'showUntilCompleted': showUntilCompleted,
      'frequencyType': frequencyType.toMap(),
      'date': date.millisecondsSinceEpoch,
      'weekdays': weekdays.map((x) => x.toMap()).toList(),
      'monthdays': monthdays.map((x) => x.toMap()).toList(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
      title: map['title'] ?? '',
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      color: Color(map['color']),
      description: map['description'] ?? '',
      showUntilCompleted: map['showUntilCompleted'] ?? false,
      frequencyType: FrequencyType.fromMap(map['frequencyType']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      weekdays: List<Weekday>.from(
        map['weekdays']?.map(
          (x) => Weekday.fromMap(x),
        ),
      ),
      monthdays: List<Monthday>.from(
        map['monthdays']?.map(
          (x) => Monthday.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  Task copyWith({
    TaskId? id,
    DateTime? createdOn,
    String? title,
    IconData? icon,
    Color? color,
    String? description,
    bool? showUntilCompleted,
    FrequencyType? frequencyType,
    DateTime? date,
    List<Weekday>? weekdays,
    List<Monthday>? monthdays,
  }) {
    return Task(
      id: id ?? this.id,
      createdOn: createdOn ?? this.createdOn,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      showUntilCompleted: showUntilCompleted ?? this.showUntilCompleted,
      frequencyType: frequencyType ?? this.frequencyType,
      date: date ?? this.date,
      weekdays: weekdays ?? this.weekdays,
      monthdays: monthdays ?? this.monthdays,
    );
  }
}
