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
    return 'Task(id: $id, title: $title,)';
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
}
