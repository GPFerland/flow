import 'dart:convert';

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

  @override
  String toString() {
    return 'Routine(id: $id, title: $title, icon: $icon, color: $color, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Routine &&
        other.id == id &&
        other.title == title &&
        other.icon == icon &&
        other.color == color &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        icon.hashCode ^
        color.hashCode ^
        description.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon': icon.codePoint,
      'color': color.value,
      'description': description,
    };
  }

  factory Routine.fromMap(Map<String, dynamic> map) {
    return Routine(
      id: map['id'],
      title: map['title'] ?? '',
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      color: Color(map['color']),
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Routine.fromJson(String source) =>
      Routine.fromMap(json.decode(source));
}
