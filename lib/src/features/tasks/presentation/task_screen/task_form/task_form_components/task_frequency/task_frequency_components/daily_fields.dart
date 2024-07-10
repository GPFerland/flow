import 'package:flow/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class DailyFields extends StatelessWidget {
  const DailyFields({
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
