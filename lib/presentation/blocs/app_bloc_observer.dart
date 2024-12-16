// ignore_for_file: strict_raw_type, prefer_single_quotes, avoid_print

import 'package:bloc/bloc.dart';

/// Observes all BLoC state changes for debugging and logging.
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print("[Bloc Created] ${bloc.runtimeType}");
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print("[Bloc Changed] ${bloc.runtimeType} changed - $change");
  }
}


/// AppBlocObserver: Global State Management and Debugging Utility
///
/// This class extends BlocObserver to provide comprehensive monitoring and logging
/// of all BLoC (Business Logic Component) lifecycle events and state changes.
///
/// Key Responsibilities:
/// 1. Debugging: Tracks the creation and state transitions of all BLoCs in the application
/// 2. Logging: Provides real-time insights into state management flow
/// 3. Performance Monitoring: Helps identify potential state management bottlenecks
///
/// Usage Patterns:
/// - Automatically tracks all BLoC instances without manual intervention
/// - Prints detailed information about BLoC lifecycle and state changes
///
/// Implementation Details:
/// - `onCreate`: Logs when a new BLoC instance is created
/// - `onChange`: Captures and logs every state change within a BLoC
///
/// Best Practices:
/// - Use in development and testing environments
/// - Disable or remove in production to minimize performance overhead
///
/// Example Log Output:
/// ```
/// [Bloc Created] AuthBloc
/// [Bloc Changed] ExpenseListBloc changed - { currentState: ..., nextState: ... }
/// ```
///
/// Note: This observer provides transparency into the application's
/// state management, facilitating easier debugging and understanding
/// of complex state interactions.
