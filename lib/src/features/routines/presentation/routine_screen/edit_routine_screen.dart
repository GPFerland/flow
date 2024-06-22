// import 'package:flow/src/features/routines/domain/routine.dart';
// import 'package:flow/src/common_widgets/forms/form_utils.dart';
// import 'package:flow/src/common_widgets/forms/routine_form.dart';
// import 'package:flutter/material.dart';
// import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// Future showEditRoutineModal({
//   required BuildContext context,
//   required Routine routine,
// }) {
//   final double screenWidth = MediaQuery.of(context).size.width;
//   final double modalWidth = screenWidth * 0.9;

//   SliverWoltModalSheetPage routinePage = WoltModalSheetPage(
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
//             child: RoutineForm(
//               mode: FormMode.editing,
//               routine: routine,
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
//         routinePage,
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
import 'package:flow/src/common_widgets/empty_placeholder_widget.dart';
import 'package:flow/src/common_widgets/responsive_center.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/routines/data/local/local_routines_repository.dart';
import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/features/routines/presentation/routine_screen/routine_form.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flow/src/utils/form_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows the product page for a given product ID.
class EditRoutineScreen extends ConsumerWidget {
  const EditRoutineScreen({super.key, required this.routineId});

  final String routineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineValue = ref.watch(localRoutineStreamProvider(routineId));
    return Scaffold(
      appBar: AppBar(
        title: routineValue.value == null
            ? const Text('Routine')
            : Text(routineValue.value!.title),
      ),
      body: AsyncValueWidget<Routine?>(
        value: routineValue,
        data: (routine) => routine == null
            ? EmptyPlaceholderWidget(
                message: 'Product not found'.hardcoded,
              )
            : CustomScrollView(
                slivers: [
                  ResponsiveSliverCenter(
                    padding: const EdgeInsets.all(Sizes.p16),
                    child: RoutineForm(
                      mode: FormMode.edit,
                      routine: routine,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
