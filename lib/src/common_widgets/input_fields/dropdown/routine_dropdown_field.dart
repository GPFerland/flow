// import 'package:flow/src/features/routines/domain/routine.dart';
// import 'package:flow/src/utils/style.dart';
// import 'package:flow/src/common_widgets/input_fields/input_fields_utils.dart';
// import 'package:flutter/material.dart';

// class RoutineDropdownField extends StatelessWidget {
//   const RoutineDropdownField({
//     super.key,
//     required this.selectedRoutine,
//     required this.selectRoutine,
//     required this.routines,
//   });

//   final String? selectedRoutine;
//   final void Function(String?, String?) selectRoutine;
//   final List<Routine> routines;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       items: [
//         for (Routine routine in routines)
//           DropdownMenuItem(
//             value: routine.title,
//             child: Text(
//               routine.title!,
//               style: getTitleSmallOnPrimaryContainer(context),
//             ),
//             onTap: () {
//               selectRoutine(
//                 routine.title,
//                 routine.id,
//               );
//             },
//           ),
//       ],
//       value: selectedRoutine,
//       onChanged: (String? selected) {},
//       decoration: getTextInputFieldDecoration(
//         labelText: 'Routine',
//         context: context,
//       ),
//     );
//   }
// }
