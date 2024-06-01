import 'package:flow/utils/style.dart';
import 'package:flow/widgets/app_bar/default_app_bar.dart';
import 'package:flow/screens/tasks/widgets/reorderable_task_list.dart';
import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: Text(
          'Tasks',
          style: getTitleLargeOnPrimary(
            context,
          ),
        ),
        showBackButton: true,
      ),
      body: const ReorderableTaskList(),
    );
  }
}
