// ignore_for_file: cascade_invocations, unnecessary_lambdas, strict_raw_type

import 'package:expense_tracking/data/datasources/api/dio_service_manager.dart';
import 'package:expense_tracking/data/datasources/api/iservice_manager.dart';
import 'package:expense_tracking/data/datasources/local/local_storage_source.dart';
import 'package:expense_tracking/data/datasources/local/shared_preferences/shared_pref_source.dart';
import 'package:expense_tracking/data/repositories/currency_repository_impl.dart';
import 'package:expense_tracking/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracking/domain/entities/expense.dart';
import 'package:expense_tracking/domain/repositories/currency_repository.dart';
import 'package:expense_tracking/domain/repositories/expense_repository.dart';
import 'package:expense_tracking/domain/usecases/calculate_cross_rate_use_case.dart';
import 'package:expense_tracking/domain/usecases/create_or_update_expense_use_case.dart';
import 'package:expense_tracking/domain/usecases/delete_expense_use_case.dart';
import 'package:expense_tracking/domain/usecases/get_all_expenses_use_case.dart';
import 'package:expense_tracking/domain/usecases/get_conversion_rates_use_case.dart';
import 'package:expense_tracking/domain/usecases/save_currency_preference_use_case.dart';
import 'package:expense_tracking/presentation/blocs/auth/auth_bloc.dart';
import 'package:expense_tracking/presentation/blocs/currency_update/currency_update_bloc.dart';
import 'package:expense_tracking/presentation/blocs/expense_form/expense_form_bloc.dart';
import 'package:expense_tracking/presentation/blocs/expense_list/expense_list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global service locator instance
final sl = GetIt.instance;

/// Initializes all dependencies required for the app.
/// Make sure to call this method before runApp() in main.dart.
Future<void> initializeDependencies() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Data Sources
  sl.registerLazySingleton<IserviceManager>(() => DioServiceManager());
  sl.registerLazySingleton<LocalStorageSource>(
    () => SharedPreferencesSource(sl()),
  );

  // Repositories (Implementation bound to Domain Interfaces)
  sl.registerLazySingleton<IExpenseRepository>(
    () => ExpenseRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<ICurrencyRepository>(
    () => CurrencyRepositoryImpl(
      storage: sl<LocalStorageSource>(),
      serviceManager: sl<IserviceManager>(),
    ),
  );

  // Domain Use Cases
  sl.registerFactory<GetAllExpensesUseCase>(
    () => GetAllExpensesUseCase(sl<IExpenseRepository>()),
  );
  sl.registerFactory<DeleteExpenseUseCase>(
    () => DeleteExpenseUseCase(sl<IExpenseRepository>()),
  );
  sl.registerFactory<CreateOrUpdateExpenseUseCase>(
    () => CreateOrUpdateExpenseUseCase(sl<IExpenseRepository>()),
  );

  sl.registerFactory<GetConversionRatesUseCase>(
    () => GetConversionRatesUseCase(sl<ICurrencyRepository>()),
  );
  sl.registerFactory<SaveCurrencyPreferenceUseCase>(
    () => SaveCurrencyPreferenceUseCase(sl<ICurrencyRepository>()),
  );
  sl.registerFactory<CalculateCrossRateUseCase>(
    () => CalculateCrossRateUseCase(),
  );

  // Retrieve initial preferences for CurrencyUpdateBloc
  final initialCurrency = sl<ICurrencyRepository>().getCurrencyPreference();

  // BLoCs
  sl.registerFactory<AuthBloc>(() => AuthBloc());

  sl.registerFactory<CurrencyUpdateBloc>(
    () => CurrencyUpdateBloc(
      getConversionRatesUseCase: sl<GetConversionRatesUseCase>(),
      saveCurrencyPreferenceUseCase: sl<SaveCurrencyPreferenceUseCase>(),
      calculateCrossRateUseCase: sl<CalculateCrossRateUseCase>(),
      initialCurrencyPreference: initialCurrency,
    ),
  );

  sl.registerFactory<ExpenseListBloc>(
    () => ExpenseListBloc(
      getAllExpensesUseCase: sl<GetAllExpensesUseCase>(),
      deleteExpenseUseCase: sl<DeleteExpenseUseCase>(),
    ),
  );

  // Using factoryParam for ExpenseFormBloc to optionally pass an Expense
  sl.registerFactoryParam<ExpenseFormBloc, Expense?, void>(
    (expense, _) => ExpenseFormBloc(
      initialExpense: expense,
      createOrUpdateExpenseUseCase: sl<CreateOrUpdateExpenseUseCase>(),
    ),
  );
}
