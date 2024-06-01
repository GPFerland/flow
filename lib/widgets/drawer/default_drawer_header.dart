import 'package:flow/utils/date.dart';
import 'package:flow/utils/firestore.dart';
import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';

class DefaultDrawerHeader extends StatelessWidget {
  const DefaultDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'flow',
          style: getTitleLargeOnSecondaryContainer(
            context,
            fontSize: 32,
          ),
        ),
        Text(
          getFormattedDateString(
            DateTime.now(),
          ),
        ),
        Text(
          getUserEmail() ?? 'email@email.com',
        ),
      ],
    );
  }
}
