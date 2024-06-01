import 'package:flow/screens/routines/routines_screen.dart';
import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';

class ShowRoutinesScreenButton extends StatelessWidget {
  const ShowRoutinesScreenButton({super.key});

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
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RoutinesScreen()),
          );
        },
        child: Text(
          'Routines',
          style: getTitleMediumOnSecondaryContainer(context),
        ),
      ),
    );
  }
}
