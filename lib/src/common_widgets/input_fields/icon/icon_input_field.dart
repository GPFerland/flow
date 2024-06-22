import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

//todo - this does not work because the icons are not included in the deployment
class IconInputField extends StatelessWidget {
  const IconInputField({
    super.key,
    required this.iconKey,
    this.selectedIcon,
    this.selectedColor,
    required this.selectIcon,
    this.readOnly = false,
  });

  final Key iconKey;
  final IconData? selectedIcon;
  final Color? selectedColor;
  final void Function(IconData) selectIcon;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: iconKey,
      onTap: readOnly
          ? null
          : () async {
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
