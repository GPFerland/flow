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
}
