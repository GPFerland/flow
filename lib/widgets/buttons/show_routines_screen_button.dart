import 'package:flow/screens/home/routines_screen.dart';
import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';

class ShowRoutinesScreenButton extends StatelessWidget {
  const ShowRoutinesScreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RoutinesScreen()),
        );
      },
      child: SizedBox(
        height: drawerTileHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                'Routines',
                style: getTitleLargeOnSecondaryContainer(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
