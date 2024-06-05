import 'package:flow/data/models/routine.dart';
import 'package:flow/widgets/forms/form_utils.dart';
import 'package:flow/widgets/forms/routine_form.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

Future showEditRoutineModal({
  required BuildContext context,
  required Routine routine,
}) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double modalWidth = screenWidth * 0.9;

  SliverWoltModalSheetPage routinePage = WoltModalSheetPage(
    hasTopBarLayer: false,
    child: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 2, 0, 6),
            child: RoutineForm(
              mode: FormMode.editing,
              routine: routine,
            ),
          ),
        ],
      ),
    ),
  );

  return WoltModalSheet.show<void>(
    context: context,
    maxDialogWidth: modalWidth > 640 ? 640 : modalWidth,
    pageListBuilder: (modalSheetContext) {
      return [
        routinePage,
      ];
    },
    modalTypeBuilder: (context) {
      return WoltModalType.dialog;
    },
    onModalDismissedWithBarrierTap: () {
      debugPrint('Closed modal sheet with barrier tap');
      Navigator.of(context).pop();
    },
  );
}
