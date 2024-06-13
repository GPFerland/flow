import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/routines/data/local/local_routines_repository.dart';
import 'package:flow/src/features/routines/domain/routines.dart';
import 'package:flow/src/features/routines/presentation/routine_list_card/routine_list_card.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutinesList extends ConsumerWidget {
  const RoutinesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesListValue = ref.watch(localRoutinesStreamProvider);
    return AsyncValueWidget<Routines>(
      value: routinesListValue,
      data: (routines) => routines.routinesList.isEmpty
          ? Center(
              child: Text(
                'No routines found'.hardcoded,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: Sizes.p8),
              child: ListView.builder(
                //todo - this is not good, figure out the good way to do this.
                shrinkWrap: true,
                itemCount: routines.routinesList.length,
                itemBuilder: (context, index) {
                  final routine = routines.routinesList[index];
                  return RoutineListCard(
                    routine: routine,
                  );
                },
              ),
            ),
    );
  }
}
