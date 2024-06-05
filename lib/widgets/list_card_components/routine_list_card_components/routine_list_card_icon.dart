import 'package:flow/data/models/routine.dart';
import 'package:flutter/material.dart';

class RoutineListCardIcon extends StatelessWidget {
  const RoutineListCardIcon({
    super.key,
    required this.routine,
  });

  final Routine routine;

  @override
  Widget build(BuildContext context) {
    return Icon(
      routine.icon,
      color: routine.color,
      size: 30,
    );
  }
}
