// import 'package:flow/src/features/tasks/domain/task.dart';
// import 'package:flow/src/features/task_instances/domain/task_instance.dart';
// import 'package:flow/src/common_widgets/FUCK/providers/date/selected_date_provider.dart';
// import 'package:flow/src/utils/date.dart';
// import 'package:flow/src/utils/style.dart';
// import 'package:flow/src/common_widgets/buttons/reschedule_task_button.dart';
// import 'package:flow/src/common_widgets/buttons/skip_task_button.dart';
// import 'package:flow/src/common_widgets/dividers/divider_on_primary_container.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ScheduleTaskForm extends ConsumerStatefulWidget {
//   const ScheduleTaskForm({
//     super.key,
//     required this.task,
//     required this.taskInstance,
//   });

//   final Task task;
//   final TaskInstance taskInstance;

//   @override
//   ConsumerState<ScheduleTaskForm> createState() {
//     return _RescheduleTaskFormState();
//   }
// }

// class _RescheduleTaskFormState extends ConsumerState<ScheduleTaskForm> {
//   DateTime? rescheduledDate;

//   Future<void> _selectDate() async {
//     DateTime firstDate = getDateNoTime(DateTime.now());
//     firstDate =
//         firstDate.isBefore(rescheduledDate!) ? firstDate : rescheduledDate!;

//     DateTime? lastDate = widget.task.getNextScheduledDate(rescheduledDate!);
//     if (lastDate != null) {
//       lastDate = lastDate.subtract(
//         const Duration(days: 1),
//       );
//     }

//     DateTime? newDate = await selectDate(
//       context: context,
//       initialDate: rescheduledDate!,
//       firstDate: firstDate,
//       lastDate: lastDate,
//     );

//     if (newDate != null) {
//       setState(() {
//         rescheduledDate = newDate;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     DateTime date = ref.read(dateProvider);
//     rescheduledDate ??= date;

//     DateTime? nextScheduledDate = widget.task.getNextScheduledDate(date);

//     //todo - this form is shitty, make it easier to understand
//     return Padding(
//       padding: const EdgeInsets.only(top: 8),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Text(
//           widget.task.title!,
//           style: getTitleLargeOnPrimaryContainer(context),
//         ),
//         const Padding(
//           padding: EdgeInsets.only(top: 8.0),
//           child: DividerOnPrimaryContainer(),
//         ),
//         ListTile(
//           dense: true,
//           leading: const Icon(Icons.edit_calendar_rounded),
//           title: Text(
//             'Scheduled',
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           trailing: Text(
//             getFormattedDateString(rescheduledDate!),
//             style: getBodyMediumOnPrimaryContainer(context),
//             overflow: TextOverflow.fade,
//             maxLines: 1,
//           ),
//           onTap: () {
//             _selectDate();
//           },
//         ),
//         if (nextScheduledDate != null)
//           ListTile(
//             dense: true,
//             leading: const Icon(Icons.calendar_month),
//             title: Text(
//               'Next On',
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             trailing: Text(
//               getFormattedDateString(nextScheduledDate),
//               style: getBodyMediumOnPrimaryContainer(context),
//               overflow: TextOverflow.fade,
//               maxLines: 1,
//             ),
//           ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             SkipTaskButton(
//               taskInstance: widget.taskInstance,
//               date: date,
//             ),
//             RescheduleTaskButton(
//               taskInstance: widget.taskInstance,
//               rescheduledDate: rescheduledDate!,
//             )
//           ],
//         ),
//       ]),
//     );
//   }
// }
