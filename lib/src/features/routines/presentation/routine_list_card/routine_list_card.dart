import 'package:flow/src/features/routines/presentation/routine_list_card/routine_list_card_components/routine_list_card_icon.dart';
import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutineListCard extends StatelessWidget {
  const RoutineListCard({
    super.key,
    required this.routine,
  });

  final Routine routine;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        context.goNamed(
          AppRoute.routine.name,
          pathParameters: {'id': routine.id},
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              RoutineListCardIcon(
                routine: routine,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  routine.title,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
