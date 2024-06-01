import 'package:flow/utils/style.dart';
import 'package:flow/widgets/app_bar/default_app_bar.dart';
import 'package:flow/screens/routines/widgets/reorderable_routine_list.dart';
import 'package:flutter/material.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: Text(
          'Routines',
          style: getTitleLargeOnPrimary(
            context,
          ),
        ),
        showBackButton: true,
      ),
      body: const ReorderableRoutineList(),
    );
  }
}
