import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';

class ShowSelectedDateListScreenButton extends StatelessWidget {
  const ShowSelectedDateListScreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'List',
          style: getTitleMediumOnPrimary(context),
        ),
      ),
    );
  }
}
