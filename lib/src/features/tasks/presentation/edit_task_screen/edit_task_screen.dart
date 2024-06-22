// import 'package:flow/src/features/tasks/domain/task.dart';
// import 'package:flow/src/common_widgets/forms/form_utils.dart';
// import 'package:flow/src/common_widgets/forms/task_form.dart';
// import 'package:flutter/material.dart';
// import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// Future showEditTaskModal({
//   required BuildContext context,
//   required Task task,
// }) {
//   final double screenWidth = MediaQuery.of(context).size.width;
//   final double modalWidth = screenWidth * 0.9;

//   SliverWoltModalSheetPage taskPage = WoltModalSheetPage(
//     hasTopBarLayer: false,
//     child: Container(
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 2, 0, 6),
//             child: TaskForm(
//               mode: FormMode.editing,
//               task: task,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );

//   return WoltModalSheet.show<void>(
//     context: context,
//     maxDialogWidth: modalWidth > 640 ? 640 : modalWidth,
//     pageListBuilder: (modalSheetContext) {
//       return [
//         taskPage,
//       ];
//     },
//     modalTypeBuilder: (context) {
//       return WoltModalType.dialog;
//     },
//     onModalDismissedWithBarrierTap: () {
//       debugPrint('Closed modal sheet with barrier tap');
//       Navigator.of(context).pop();
//     },
//   );
// }

import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/features/tasks/presentation/edit_task_screen/delete_task_button.dart';
import 'package:flow/src/common_widgets/empty_placeholder_widget.dart';
import 'package:flow/src/common_widgets/responsive_center.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/presentation/task_form/task_form.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows the task page for a given task Id.
class EditTaskScreen extends ConsumerWidget {
  const EditTaskScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskValue = ref.watch(localTaskStreamProvider(taskId));
    return Scaffold(
      appBar: AppBar(
        title: taskValue.value == null
            ? const Text('Task')
            : Text(taskValue.value!.title),
        actions: taskValue.value == null
            ? null
            : [DeleteTaskButton(task: taskValue.value!)],
      ),
      body: AsyncValueWidget<Task?>(
        value: taskValue,
        data: (task) => task == null
            ? EmptyPlaceholderWidget(
                message: 'Task not found'.hardcoded,
              )
            : CustomScrollView(
                slivers: [
                  ResponsiveSliverCenter(
                    padding: const EdgeInsets.all(Sizes.p16),
                    child: TaskForm(task: task),
                  ),
                ],
              ),
      ),
    );
  }
}
