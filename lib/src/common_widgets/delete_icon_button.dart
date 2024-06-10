// import 'package:flow/src/features/routines/domain/routine.dart';
// import 'package:flow/src/features/tasks/domain/task.dart';
// import 'package:flow/src/common_widgets/FUCK/providers/models/routines_provider.dart';
// import 'package:flow/src/common_widgets/FUCK/providers/models/tasks_provider.dart';
// import 'package:flow/src/utils/style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DeleteIconButton extends ConsumerWidget {
//   const DeleteIconButton({
//     super.key,
//     required this.item,
//   });

//   final Object item;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     String title = 'Delete Item';
//     String content = 'Are you sure you want to delete this item?';
//     void Function() onDeletePressed = () {
//       Navigator.of(context).pop(true);
//     };
//     if (item is Routine) {
//       title = 'Delete Routine';
//       content =
//           'Are you sure you want to delete the\n${(item as Routine).title} routine?';
//       onDeletePressed = () {
//         ref.read(routinesProvider.notifier).deleteRoutine(
//               (item as Routine),
//               context,
//             );
//         ref.read(tasksProvider.notifier).removeRoutineFromTasks(
//               (item as Routine),
//               context,
//             );
//         Navigator.of(context).pop(true);
//       };
//     } else if (item is Task) {
//       title = 'Delete Task';
//       content =
//           'Are you sure you want to delete the\n${(item as Task).title} task?';
//       onDeletePressed = () {
//         ref.read(tasksProvider.notifier).deleteTask(
//               (item as Task),
//               context,
//             );
//         Navigator.of(context).pop(true);
//       };
//     }

//     return IconButton(
//       icon: const Icon(Icons.delete),
//       color: Theme.of(context).colorScheme.onPrimaryContainer,
//       iconSize: 28,
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               elevation: 5.0,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Text(
//                       title,
//                       style: getTitleLargeOnPrimaryContainer(context),
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     Text(
//                       content,
//                       textAlign: TextAlign.center,
//                       style: getBodyLargeOnPrimaryContainer(context),
//                     ),
//                     const SizedBox(height: 24),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         OutlinedButton(
//                           onPressed: () {
//                             Navigator.of(context).pop(false);
//                           },
//                           child: const Text('Cancel'),
//                         ),
//                         ElevatedButton(
//                           onPressed: onDeletePressed,
//                           child: const Text('Delete'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ).then((value) {
//           if (value == true) {
//             Navigator.pop(context);
//           }
//         });
//       },
//     );
//   }
// }
