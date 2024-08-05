import 'package:firebase_core/firebase_core.dart';
import 'package:flow/firebase_options.dart';
import 'package:flow/src/flow_app_bootstrap.dart';
import 'package:flow/src/flow_app_providers_production.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  // create a flow app bootstrap instance
  final flowAppBootstrap = FlowAppBootstrap();
  // setup emulators to imitate the backend
  flowAppBootstrap.setupEmulators();
  // create a container configured with the production repositories
  final container = await createProductionProviderContainer();
  // use the container above to create the root widget
  final root = flowAppBootstrap.createRootWidget(providerContainer: container);
  // start the app
  runApp(root);
}
