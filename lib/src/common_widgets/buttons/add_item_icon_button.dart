import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddItemIconButton extends StatelessWidget {
  const AddItemIconButton({
    super.key,
    required this.namedRoute,
  });

  final String namedRoute;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        context.goNamed(namedRoute);
      },
    );
  }
}
