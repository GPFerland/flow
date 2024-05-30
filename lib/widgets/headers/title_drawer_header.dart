import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';

class DefaultDrawerHeader extends StatelessWidget {
  const DefaultDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.only(top: 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'flow',
            style: getTitleLargeOnPrimary(context, fontSize: 48),
          ),
        ],
      ),
    );
  }
}
