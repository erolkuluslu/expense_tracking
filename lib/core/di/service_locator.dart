// ignore_for_file: cascade_invocations, unnecessary_lambdas, strict_raw_type

import 'package:expense_tracking/core/constants/app_constants.dart';
import 'package:expense_tracking/data/datasources/services/dio_service_manager.dart';
import 'package:expense_tracking/data/datasources/services/iservice_manager.dart';
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

/// Service Locator and Dependency Injection Management
///
/// This class serves as the central dependency injection and service locator for the entire application.
/// It uses the GetIt package to manage and provide dependencies across different layers of the app.
///
/// Key Responsibilities:
/// 1. Centralized Dependency Management: Registers and provides instances of various classes
///    used throughout the application, ensuring a single source of truth for dependencies.
///
/// 2. Dependency Lifetime Management:
///    - Singleton: Long-lived, single instance dependencies (e.g., SharedPreferences, ServiceManagers)
///    - Factory: New instance created each time (e.g., BLoCs, Use Cases)
///    - Lazy Singleton: Instantiated only when first accessed (e.g., Repositories)
///
/// 3. Dependency Hierarchy and Layer Separation:
///    - External Dependencies: Third-party libraries and system services
///    - Data Sources: Local storage and network service interfaces
///    - Repositories: Bridge between data sources and domain layer
///    - Use Cases: Business logic and application-specific operations
///    - BLoCs: State management and business logic for presentation layer
///
/// Dependency Registration Patterns:
/// - `registerSingleton`: For system-wide, single-instance dependencies
/// - `registerLazySingleton`: For dependencies that are expensive to create but used multiple times
/// - `registerFactory`: For dependencies that need a fresh instance each time
/// - `registerFactoryParam`: For dependencies that require runtime parameters
///
/// Usage Example:
/// final authBloc = sl<AuthBloc>();
///
/// Best Practices:
/// - Always call `initializeDependencies()` before `runApp()`
/// - Use service locator for loose coupling between components
/// - Avoid direct instantiation of classes that are registered here
///
/// Note: This approach promotes:
/// - Modularity
/// - Testability
/// - Separation of Concerns
/// - Easier Dependency Management

/// Global service locator instance
final sl = GetIt.instance;

/// Initializes all dependencies required for the app.
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
  // ignore: unused_local_variable
  final initialCurrency = sl<ICurrencyRepository>().getCurrencyPreference();

  // BLoCs
  sl.registerFactory<AuthBloc>(() => AuthBloc());

  sl.registerFactory<CurrencyUpdateBloc>(
    () => CurrencyUpdateBloc(
      getConversionRatesUseCase: sl<GetConversionRatesUseCase>(),
      saveCurrencyPreferenceUseCase: sl<SaveCurrencyPreferenceUseCase>(),
      calculateCrossRateUseCase: sl<CalculateCrossRateUseCase>(),
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
