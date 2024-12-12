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
