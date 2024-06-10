// import 'package:flow/src/features/routines/domain/routine.dart';
// import 'package:flow/src/features/tasks/domain/task.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class TaskListCardTitle extends ConsumerWidget {
//   const TaskListCardTitle({
//     super.key,
//     required this.task,
//     this.routine,
//     this.showRoutine = false,
//   });

//   final Task task;
//   final Routine? routine;
//   final bool showRoutine;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     Color? color = routine != null ? routine!.color : task.color;
//     String? routineTitle;

//     if (showRoutine) {
//       if (routine != null) {
//         routineTitle = routine!.title;
//       } else {
//         routineTitle =
//             ref.read(routinesProvider.notifier).getRoutineTitleFromId(
//                   task.routineId,
//                 );
//       }
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           task.title,
//           style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                 color: color,
//               ),
//           overflow: TextOverflow.ellipsis,
//           maxLines: 1,
//         ),
//         if (routineTitle != null)
//           Text(
//             routineTitle,
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//           ),
//       ],
//     );
//   }
// }
