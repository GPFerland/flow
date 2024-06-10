import 'package:flow/src/features/routines/domain/routine.dart';
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
