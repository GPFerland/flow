import 'package:flow/src/common_widgets/responsive_center.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/presentation/task_form/task_form.dart';
import 'package:flutter/material.dart';

/// Shows the create task page.
class CreateTaskScreen extends StatelessWidget {
  const CreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: const CustomScrollView(
        slivers: [
          ResponsiveSliverCenter(
            padding: EdgeInsets.all(Sizes.p16),
            child: TaskForm(),
          ),
        ],
      ),
    );
  }
}
