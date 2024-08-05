import 'package:firebase_core/firebase_core.dart';
import 'package:flow/firebase_options.dart';
import 'package:flow/src/flow_app_bootstrap.dart';
import 'package:flow/src/flow_app_providers_fake.dart';
import 'package:flutter/material.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  // ensure URL changes in the address bar when using push / pushNamed
  // more info here: https://docs.google.com/document/d/1VCuB85D5kYxPR3qYOjVmw8boAGKb7k62heFyfFHTOvw/edit
  GoRouter.optionURLReflectsImperativeAPIs = true;
  // create a flow app bootstrap instance
  final flowAppBootstrap = FlowAppBootstrap();
  // setup emulators to imitate the backend
  flowAppBootstrap.setupEmulators();
  // create a container configured with the fake repositories
  final container = await createFakeProviderContainer();
  // use the container above to create the root widget
  final root = flowAppBootstrap.createRootWidget(providerContainer: container);
  // start the app
  runApp(root);
}
