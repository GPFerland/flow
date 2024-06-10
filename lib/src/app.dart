import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

//todo - the way I am loading in Icons is assssssss!!!!!

//todo - I need to figure out how to use Icons better because its fucking me up

//todo - Use SafeArea to avoid native device hardware, cameras, notches, shit

//todo - remove any secret keys from the git repo and ignore them going forward

//todo - When I skip a task it does not immediatly remove itself from the list, its inconsistent, seems more like an issue with monthly tasks???

//todo - cap the width of the comfirmation dialog

//todo - Refresh with a pulldown????

//todo - only show tasks after their creation date!!!!!

class FlowApp extends ConsumerWidget {
  const FlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      onGenerateTitle: (BuildContext context) => 'flow'.hardcoded,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
