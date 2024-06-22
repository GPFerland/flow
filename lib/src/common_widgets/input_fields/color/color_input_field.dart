import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class ColorInputField extends StatelessWidget {
  const ColorInputField({
    super.key,
    required this.colorKey,
    required this.selectedColor,
    required this.selectColor,
    this.readOnly = false,
  });

  final Key colorKey;
  final Color selectedColor;
  final void Function(BuildContext, Color) selectColor;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    Color tempColor = selectedColor;

    return GestureDetector(
      key: colorKey,
      onTap: readOnly
          ? null
          : () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: AlertDialog(
                      contentPadding: const EdgeInsets.all(4),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 4,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Select Color',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      selectColor(context, tempColor);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.check),
                                  ),
                                ],
                              ),
                            ),
                            ColorPicker(
                              padding: const EdgeInsets.only(
                                top: 0,
                                left: 6,
                                right: 6,
                                bottom: 6,
                              ),
                              color: selectedColor,
                              onColorChanged: (Color color) {
                                tempColor = color;
                              },
                              subheading: Text(
                                'Select color shade',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              width: 44,
                              height: 44,
                              borderRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
      child: Container(
        height: 44,
        width: 44,
        margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
        decoration: BoxDecoration(
          color: selectedColor,
          border: Border.all(
            width: 2.0,
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
