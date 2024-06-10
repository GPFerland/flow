import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';

class ReorderableTaskListTitle extends StatelessWidget {
  const ReorderableTaskListTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Tasks',
      style: getTitleLargeOnPrimary(context),
    );
  }
}
