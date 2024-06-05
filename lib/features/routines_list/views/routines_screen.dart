import 'package:flow/features/routines_list/widgets/reorderable_routine_list.dart';
import 'package:flutter/material.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ReorderableRoutineList(),
      ),
    );
  }
}
