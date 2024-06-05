import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';

class ReorderableRoutineListTitle extends StatelessWidget {
  const ReorderableRoutineListTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Routines',
      style: getTitleLargeOnPrimary(context),
    );
  }
}
