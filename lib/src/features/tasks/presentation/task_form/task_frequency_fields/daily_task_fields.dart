import 'package:flutter/material.dart';

class DailyTaskFields extends StatefulWidget {
  const DailyTaskFields({
    super.key,
  });

  @override
  State<DailyTaskFields> createState() => _DailyTaskFieldsState();
}

class _DailyTaskFieldsState extends State<DailyTaskFields> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Everyday'));
  }
}
