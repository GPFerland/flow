import 'package:flow/utils/firestore.dart';
import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';

class DrawerFooterTile extends StatelessWidget {
  const DrawerFooterTile({super.key});

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5.0,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Confirm Logout',
                  style: getTitleLargeOnPrimaryContainer(context),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        logOutUser();
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              Text(
                getUserEmail() ?? 'email@email.com',
                style: getBodyLargeOnSecondaryContainer(context),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  _showLogoutConfirmationDialog(context);
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
        Container(
          color: Theme.of(context).colorScheme.primary,
          width: double.infinity,
          child: Text(
            'Created by PineWoodYogi',
            style: getBodyMediumOnPrimary(context),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
