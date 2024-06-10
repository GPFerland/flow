// import 'package:flow/src/features/task_instances/domain/task_instance.dart';
// import 'package:flow/src/common_widgets/FUCK/providers/models/task_instances_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class RescheduleTaskButton extends ConsumerWidget {
//   const RescheduleTaskButton({
//     super.key,
//     required this.taskInstance,
//     required this.rescheduledDate,
//   });

//   final TaskInstance taskInstance;
//   final DateTime rescheduledDate;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ElevatedButton(
//       onPressed: () {
//         taskInstance.rescheduledDate = rescheduledDate;
//         ref.read(taskInstancesProvider.notifier).updateItem(
//               taskInstance,
//               //context,
//             );
//         Navigator.pop(context);
//       },
//       child: const Text('Save'),
//     );
//   }
// }
