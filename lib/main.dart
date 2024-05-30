import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flow/providers/future/user_data_future_provider.dart';
import 'package:flow/providers/theme/theme_provider.dart';
import 'package:flow/screens/auth/auth_screen.dart';
import 'package:flow/screens/error/error_screen.dart';
import 'package:flow/screens/home/list_screen.dart';
import 'package:flow/screens/loading/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

//todo - make sure this looks good on Chrome

//todo - When a task or routine is added and the user is on the Tasks or Routines page
// scroll till they get to the new entry automatically

//todo - although its way better, the transition after a change in theme color
// or dark mode is still dog shit

//todo - think about seperating the local and remote so the user can make
// updates without service and it will update the remote once a connetion is
// reestablished

//todo - Overdue tasks are not showing up on the day they were completed

//todo - make sure that tasks marked as show until completed are showing up until completed

//todo - I should add logging to this, what the fuck is logging

//todo - do something so the date gets updated when the time changes to the next day
// could this be aided by a datetime provider???????

//todo - go through every file and add comments you dumb bitch

//todo - go everywhere and make sure that all widgets are using the selectedDate provider

//todo - get common heights for all of the list tiles and store those in a good location

//todo - make sure any stateful widgets are necessary, they actually call set state

//todo - make the default drawer look better, it looks like shit right now

//todo - figure out how I can reschedule a task earlier than it would normally show up

//todo - combine all of the confirmation dialog code that is similar

//todo - Should I delete one time tasks after they are completed??????

//todo - Give a theme options to let a user disable the Today, Yesterday, Tomorrow in the heading

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: FlowApp(),
    ),
  );
}

class FlowApp extends ConsumerWidget {
  const FlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'flow',
      theme: ref.watch(themeProvider),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshot.hasData) {
            return ref.watch(userDataFutureProvider).when(
              data: (data) {
                return const ListScreen();
              },
              error: (Object error, StackTrace stackTrace) {
                return ErrorScreen(error: error);
              },
              loading: () {
                return const LoadingScreen();
              },
            );
          }
          return const AuthScreen();
        },
      ),
    );
  }
}