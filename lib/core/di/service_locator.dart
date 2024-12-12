// ignore_for_file: cascade_invocations, unnecessary_lambdas, strict_raw_type

import 'package:expense_tracking/data/datasources/api/iservice_manager.dart';
import 'package:expense_tracking/data/datasources/local/local_storage_source.dart';
import 'package:expense_tracking/data/datasources/local/shared_preferences/shared_pref_source.dart';
import 'package:expense_tracking/data/repositories/currency_repository.dart';
import 'package:expense_tracking/data/repositories/expense_repository.dart';
import 'package:expense_tracking/presentation/blocs/auth/auth_bloc.dart';
import 'package:expense_tracking/presentation/blocs/currency_update/currency_update_bloc.dart';
import 'package:expense_tracking/presentation/blocs/expense_form/expense_form_bloc.dart';
import 'package:expense_tracking/presentation/blocs/expense_list/expense_list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/api/dio_service_manager.dart';

/// Global service locator instance
final sl = GetIt.instance;

/// Initializes all dependencies
Future<void> initializeDependencies() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Data Sources
  sl.registerLazySingleton<IserviceManager>(
    () => DioServiceManager(),
  );

  sl.registerLazySingleton<LocalStorageSource>(
    () => SharedPreferencesSource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepository(storage: sl()),
  );

  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepository(
      storage: sl(),
      serviceManager: sl(),
    ),
  );

  // BLoCs
  sl.registerFactory<AuthBloc>(
    AuthBloc.new,
  );

  sl.registerFactory<CurrencyUpdateBloc>(
    () => CurrencyUpdateBloc(
      repository: sl(),
    ),
  );

  sl.registerFactory<ExpenseListBloc>(
    () => ExpenseListBloc(
      repository: sl(),
    ),
  );

  sl.registerFactoryParam<ExpenseFormBloc, ExpenseRepository, void>(
    (repository, _) => ExpenseFormBloc(
      repository: repository,
    ),
  );
}
