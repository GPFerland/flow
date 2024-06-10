import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flutter/material.dart';

class DividerForRoutine extends StatelessWidget {
  const DividerForRoutine({super.key, required this.routine});

  final Routine routine;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: routine.color!.withOpacity(0.8),
    );
  }
}
