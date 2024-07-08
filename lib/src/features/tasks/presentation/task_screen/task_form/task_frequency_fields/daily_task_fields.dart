import 'package:flow/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class DailyTaskFields extends StatelessWidget {
  const DailyTaskFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(Sizes.p12),
      child: Center(
        child: Text('Everyday'),
      ),
    );
  }
}
