import 'package:flow/widgets/modals/create_item_modal.dart';
import 'package:flutter/material.dart';

class AddIconButton extends StatelessWidget {
  const AddIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        showCreateItemModal(context: context);
      },
    );
  }
}
