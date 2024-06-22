// import 'package:flow/src/features/tasks/domain/task.dart';
// import 'package:flow/src/features/task_instances/domain/task_instance.dart';
// import 'package:flow/src/common_widgets/forms/reschedule_task_form.dart';
// import 'package:flutter/material.dart';
// import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// Future showScheduleTaskModal({
//   required BuildContext context,
//   required Task task,
//   required TaskInstance taskInstance,
//   required DateTime date,
// }) {
//   final double screenWidth = MediaQuery.of(context).size.width;
//   final double modalWidth = screenWidth * 0.9;

//   SliverWoltModalSheetPage scheduleTaskPage = WoltModalSheetPage(
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
//             child: ScheduleTaskForm(
//               task: task,
//               taskInstance: taskInstance,
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
//         scheduleTaskPage,
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