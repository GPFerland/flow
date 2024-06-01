import 'package:flow/screens/selected_date_list/widgets/floating_action_buttons/show_completed_items_button.dart';
import 'package:flow/screens/selected_date_list/widgets/floating_action_buttons/show_next_day_button.dart';
import 'package:flow/screens/selected_date_list/widgets/floating_action_buttons/show_previous_day_button.dart';
import 'package:flutter/material.dart';

class FloatingActionButtons extends StatelessWidget {
  const FloatingActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  child: const ShowCompletedItemsButton(),
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
