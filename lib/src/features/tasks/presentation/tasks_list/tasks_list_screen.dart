import 'package:flow/src/common_widgets/buttons/add_item_icon_button.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list/tasks_list/tasks_list.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list/tasks_list_controller.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flow/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksListScreen extends ConsumerWidget {
  const TasksListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      tasksListControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

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
        child: TasksList(),
      ),
    );
  }
}
