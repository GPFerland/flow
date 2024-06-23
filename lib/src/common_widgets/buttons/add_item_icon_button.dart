import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddItemIconButton extends StatelessWidget {
  const AddItemIconButton({super.key, required this.namedRoute});

  final String namedRoute;

  // Keys for testing using find.byKey()
  static const addItemIconButtonKey = Key('add-item-icon-button');

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: addItemIconButtonKey,
      icon: const Icon(Icons.add),
      onPressed: () {
        context.goNamed(namedRoute);
      },
    );
  }
}
