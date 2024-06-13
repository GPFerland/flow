import 'dart:convert';

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
  });

  final TaskId id;
  final DateTime createdOn;
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final bool showUntilCompleted;

  @override
  String toString() {
    return 'Task(id: $id, title: $title)';
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
        other.showUntilCompleted == showUntilCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdOn.hashCode ^
        title.hashCode ^
        icon.hashCode ^
        color.hashCode ^
        description.hashCode ^
        showUntilCompleted.hashCode;
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}
