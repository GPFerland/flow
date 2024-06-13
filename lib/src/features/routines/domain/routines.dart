import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flow/src/features/routines/domain/routine.dart';

class Routines {
  Routines({required this.routinesList});

  final List<Routine> routinesList;

  @override
  String toString() => 'Routines(routines: $routinesList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Routines && listEquals(other.routinesList, routinesList);
  }

  @override
  int get hashCode => routinesList.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'routines': routinesList.map((x) => x.toMap()).toList(),
    };
  }

  factory Routines.fromMap(Map<String, dynamic> map) {
    return Routines(
      routinesList:
          List<Routine>.from(map['routines']?.map((x) => Routine.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Routines.fromJson(String source) =>
      Routines.fromMap(json.decode(source));
}
