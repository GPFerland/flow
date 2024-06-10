// import 'package:flow/src/common_widgets/FUCK/providers/screen/screen_provider.dart';
// import 'package:flow/src/utils/style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ShowScreenButton extends ConsumerWidget {
//   const ShowScreenButton({
//     super.key,
//     required this.screen,
//     required this.buttonTitle,
//     this.popContext = true,
//   });

//   final AppScreen screen;
//   final String buttonTitle;
//   final bool popContext;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SizedBox(
//       width: double.infinity,
//       child: TextButton(
//         style: TextButton.styleFrom(
//           backgroundColor: ref.watch(screenProvider) == screen
//               ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
//               : Theme.of(context).colorScheme.primary.withOpacity(0.1),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(25.0),
//           ),
//         ),
//         onPressed: () {
//           if (popContext) {
//             Navigator.pop(context);
//           }
//           ref.read(screenProvider.notifier).setScreen(screen);
//         },
//         child: Text(
//           buttonTitle,
//           style: ref.read(screenProvider) == screen
//               ? getTitleMediumOnPrimary(context)
//               : getTitleMediumOnSecondaryContainer(context),
//         ),
//       ),
//     );
//   }
// }
