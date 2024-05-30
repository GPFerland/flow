import 'package:flow/models/routine.dart';
import 'package:flutter/material.dart';

class RoutineListTileIcon extends StatelessWidget {
  const RoutineListTileIcon({
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
