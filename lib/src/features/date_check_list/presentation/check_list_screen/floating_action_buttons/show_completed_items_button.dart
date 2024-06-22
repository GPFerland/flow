// import 'package:flow/src/common_widgets/FUCK/providers/future/show_completed_future_provider.dart';
// import 'package:flow/src/common_widgets/FUCK/providers/theme/show_completed_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ShowCompletedItemsButton extends ConsumerWidget {
//   const ShowCompletedItemsButton({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ref.watch(showCompletedProvider);

//     return ref.watch(showCompletedFutureProvider).when(
//       loading: () {
//         return FloatingActionButton.extended(
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           foregroundColor: Theme.of(context).colorScheme.onPrimary,
//           label: const CircularProgressIndicator(),
//           onPressed: () {},
//         );
//       },
//       data: (data) {
//         final bool showCompleted = ref.read(showCompletedProvider);
//         return FloatingActionButton.extended(
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           foregroundColor: Theme.of(context).colorScheme.onPrimary,
//           label: Text(showCompleted ? 'Hide Completed' : 'Show Completed'),
//           onPressed: () {
//             ref.read(showCompletedProvider.notifier).updateShowCompleted(
//                   !showCompleted,
//                   context,
//                 );
//           },
//         );
//       },
//       error: (Object error, StackTrace stackTrace) {
//         return FloatingActionButton.extended(
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           foregroundColor: Theme.of(context).colorScheme.onPrimary,
//           label: const Icon(Icons.not_interested),
//           onPressed: () {},
//         );
//       },
//     );
//   }
// }
