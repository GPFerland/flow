import 'package:flow/models/routine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutineListTileTitle extends ConsumerWidget {
  const RoutineListTileTitle({
    super.key,
    required this.routine,
  });

  final Routine routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      routine.title!,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: routine.color,
          ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
