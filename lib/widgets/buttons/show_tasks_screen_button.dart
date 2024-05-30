import 'package:flow/screens/home/tasks_screen.dart';
import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';

class ShowTasksScreenButton extends StatelessWidget {
  const ShowTasksScreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TasksScreen()),
        );
      },
      child: SizedBox(
        height: drawerTileHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                'Tasks',
                style: getTitleLargeOnSecondaryContainer(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
