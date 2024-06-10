import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';

class DrawerAboutUsButton extends StatelessWidget {
  const DrawerAboutUsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () {
          //todo - Show a screen saying who we are!
        },
        child: Text(
          'About Us',
          style: getTitleMediumOnSecondaryContainer(context),
        ),
      ),
    );
  }
}
