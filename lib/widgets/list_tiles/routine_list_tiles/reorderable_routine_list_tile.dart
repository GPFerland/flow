import 'package:flow/models/routine.dart';
import 'package:flow/utils/style.dart';
import 'package:flow/widgets/dividers/divider_on_primary_container.dart';
import 'package:flow/widgets/list_tiles/routine_list_tiles/routine_list_tile_components/routine_list_tile_icon.dart';
import 'package:flow/widgets/list_tiles/routine_list_tiles/routine_list_tile_components/routine_list_tile_title.dart';
import 'package:flow/widgets/modals/edit_routine_modal.dart';
import 'package:flutter/material.dart';

class ReorderableRoutineListTile extends StatelessWidget {
  const ReorderableRoutineListTile({
    super.key,
    required this.routine,
  });

  final Routine routine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            showEditRoutineModal(
              context: context,
              routine: routine,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            height: listTileHeight,
            child: Row(
              children: [
                RoutineListTileIcon(
                  routine: routine,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: RoutineListTileTitle(
                    routine: routine,
                  ),
                ),
              ],
            ),
          ),
        ),
        const DividerOnPrimaryContainer(),
      ],
    );
  }
}
