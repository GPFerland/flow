import 'package:flutter/material.dart';

/// * The routine identifier is an important concept and can have its own type.
typedef RoutineId = String;

class Routine {
  Routine({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });

  final RoutineId id;
  final String title;
  final IconData icon;
  final Color color;
  final String description;
}
