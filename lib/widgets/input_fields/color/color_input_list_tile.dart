import 'package:flow/utils/style.dart';
import 'package:flow/widgets/input_fields/color/theme_color_input_field.dart';
import 'package:flutter/material.dart';

class ThemeColorListTile extends StatelessWidget {
  const ThemeColorListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: drawerTileHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Primary Color',
                style: getTitleLargeOnSecondaryContainer(context),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 7),
              child: ThemeColorInputField(),
            ),
          ],
        ),
      ),
    );
  }
}
