import 'package:flow/src/common_widgets/buttons/add_item_icon_button.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list/task_list/task_list.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flutter/material.dart';

class TasksListScreen extends StatelessWidget {
  const TasksListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
        actions: [
          AddItemIconButton(
            namedRoute: AppRoute.createTask.name,
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(Sizes.p12),
        child: TaskList(),
      ),
    );
  }
}
