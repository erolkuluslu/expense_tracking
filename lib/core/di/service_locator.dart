import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/dio_service_manager.dart';
import '../../data/datasources/iservice_manager.dart';
import '../../data/idata_storage.dart';
import '../../data/repositories/currency_repository.dart';
import '../../data/repositories/expense_repository.dart';
import '../../data/shared_pref_storage.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/currency_update/currency_update_bloc.dart';
import '../../presentation/blocs/expense_form/expense_form_bloc.dart';
import '../../presentation/blocs/expense_list/expense_list_bloc.dart';

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

  sl.registerLazySingleton<ExpenseStorage>(
    () => SharedPrefStorage(preferences: sl()),
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
    () => AuthBloc(),
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
