import 'package:flow/features/tasks_list/widgets/reorderable_task_list.dart';
import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ReorderableTaskList(),
      ),
    );
  }
}
