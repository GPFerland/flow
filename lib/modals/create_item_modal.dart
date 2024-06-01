import 'package:flow/utils/style.dart';
import 'package:flow/modals/forms/form_utils.dart';
import 'package:flow/modals/forms/routine_form.dart';
import 'package:flow/modals/forms/task_form.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

Future showCreateItemModal({
  required BuildContext context,
}) {
  final pageIndexNotifier = ValueNotifier(0);

  final double screenWidth = MediaQuery.of(context).size.width;
  final double modalWidth = screenWidth * 0.9;

  SliverWoltModalSheetPage taskPage = WoltModalSheetPage(
    enableDrag: false,
    topBarTitle: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              pageIndexNotifier.value = 0;
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primary,
              ),
              shadowColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Text(
              'Add Task',
              style: getTitleMediumOnPrimary(context),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            pageIndexNotifier.value = 1;
          },
          style: ButtonStyle(
            shadowColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          child: const Text(
            'Routine',
          ),
        ),
      ],
    ),
    isTopBarLayerAlwaysVisible: true,
    child: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 2, 0, 6),
            child: TaskForm(mode: FormMode.creating),
          ),
        ],
      ),
    ),
  );

  SliverWoltModalSheetPage routinePage = WoltModalSheetPage(
    enableDrag: false,
    topBarTitle: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            pageIndexNotifier.value = 0;
          },
          style: ButtonStyle(
            shadowColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          child: const Text('Task'),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              pageIndexNotifier.value = 1;
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primary,
              ),
              shadowColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Text(
              'Add Routine',
              style: getTitleMediumOnPrimary(context),
            ),
          ),
        ),
      ],
    ),
    isTopBarLayerAlwaysVisible: true,
    child: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 2, 0, 6),
            child: RoutineForm(mode: FormMode.creating),
          ),
        ],
      ),
    ),
  );

  return WoltModalSheet.show<void>(
    pageIndexNotifier: pageIndexNotifier,
    context: context,
    maxDialogWidth: modalWidth > 640 ? 640 : modalWidth,
    pageListBuilder: (modalSheetContext) {
      return [
        taskPage,
        routinePage,
      ];
    },
    modalTypeBuilder: (context) {
      return WoltModalType.dialog;
    },
    onModalDismissedWithBarrierTap: () {
      debugPrint('Closed modal sheet with barrier tap');
      Navigator.of(context).pop();
      pageIndexNotifier.value = 0;
    },
  );
}
