import 'package:flow/screens/tasks/tasks_screen.dart';
import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';

class ShowTasksScreenButton extends StatelessWidget {
  const ShowTasksScreenButton({super.key});

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
            MaterialPageRoute(builder: (context) => const TasksScreen()),
          );
        },
        child: Text(
          'Tasks',
          style: getTitleMediumOnSecondaryContainer(context),
        ),
      ),
    );
  }
}
