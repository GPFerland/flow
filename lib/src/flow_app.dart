import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//todo - make sure this looks good on Chrome

//todo - When a task or routine is added and the user is on the Tasks or Routines page
// scroll till they get to the new entry automatically

//todo - do something so the date gets updated when the time changes to the next day
// could this be aided by a datetime provider???????

//todo - Figure out what my comment structure is and document it somewhere

//todo - go through every file and add comments you dumb bitch

//todo - make sure any stateful widgets are necessary, they actually call set state

//todo - combine all of the confirmation dialog code that is similar

//todo - Should I delete one time tasks after they are completed??????

//todo - Give a theme options to let a user disable the Today, Yesterday, Tomorrow in the heading

//todo - the way I am loading in Icons is assssssss!!!!!

//todo - I need to figure out how to use Icons better because its fucking me up

//todo - Use SafeArea to avoid native device hardware, cameras, notches, shit

//todo - cap the width of the comfirmation dialog

//todo - think about how I handle ids for tasks and task instances
//       should firestore handle this for me or can I generate ids myself

//todo - show messages at the bottom of the page when stuff happens, creation
//       deletion, updates, all that shit

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
          centerTitle: true,
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
