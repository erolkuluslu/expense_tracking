import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/di/service_locator.dart';
import 'presentation/widgets/app_bloc_observer.dart';

/// Entry point of the application
Future<void> main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Configure Bloc observer for debugging
  Bloc.observer = AppBlocObserver();

  // Initialize dependencies
  await initializeDependencies();

  // Run the app
  runApp(const App());
}
