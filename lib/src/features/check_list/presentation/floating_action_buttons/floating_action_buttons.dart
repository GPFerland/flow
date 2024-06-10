import 'package:flow/src/features/check_list/presentation/floating_action_buttons/select_date_button.dart';
import 'package:flow/src/features/check_list/presentation/floating_action_buttons/show_next_day_button.dart';
import 'package:flow/src/features/check_list/presentation/floating_action_buttons/show_previous_day_button.dart';
import 'package:flutter/material.dart';

class FloatingActionButtons extends StatelessWidget {
  const FloatingActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 1,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final desiredWidth = constraints.maxWidth * 0.8;
                return SizedBox(
                  width: desiredWidth,
                  child: const ShowPreviousDayButton(),
                );
              },
            ),
          ),
          Flexible(
            flex: 4,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final desiredWidth = constraints.maxWidth * 0.6;
                return SizedBox(
                  width: desiredWidth,
                  child: const SelectDateButton(),
                );
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final desiredWidth = constraints.maxWidth * 0.8;
                return SizedBox(
                  width: desiredWidth,
                  child: const ShowNextDayButton(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
