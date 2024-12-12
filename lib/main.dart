// ignore_for_file: directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracking/core/di/service_locator.dart';
import 'package:expense_tracking/app.dart';
import 'package:expense_tracking/presentation/blocs/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure Bloc observer for debugging
  Bloc.observer = AppBlocObserver();

  // Initialize dependencies
  await initializeDependencies();

  // Run the app
  runApp(const App());
}
