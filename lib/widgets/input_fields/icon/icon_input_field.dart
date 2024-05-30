import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class IconInputField extends StatelessWidget {
  const IconInputField({
    super.key,
    this.selectedIcon,
    this.selectedColor,
    required this.selectIcon,
  });

  final IconData? selectedIcon;
  final Color? selectedColor;
  final void Function(IconData?) selectIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        IconData? icon = await showIconPicker(
          context,
          iconColor: selectedColor,
          title: const Text('Select Icon'),
        );
        if (icon != null) {
          selectIcon(icon);
        }
      },
      child: Container(
        height: 44,
        width: 44,
        margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.center,
          child: selectedIcon != null
              ? Icon(
                  selectedIcon,
                  size: 36,
                  color: selectedColor,
                )
              : null,
        ),
      ),
    );
  }
}
