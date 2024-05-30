import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flow/providers/theme/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeColorInputField extends ConsumerWidget {
  const ThemeColorInputField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color color = ref.watch(colorProvider);

    return GestureDetector(
      onTap: () {
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
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                ref.read(colorProvider.notifier).updateColor(
                                      color,
                                      context,
                                    );
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
                        color: color,
                        onColorChanged: (Color newColor) {
                          color = newColor;
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
        margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        decoration: BoxDecoration(
          color: color,
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
