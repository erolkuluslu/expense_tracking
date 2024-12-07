import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/theme/theme.dart';
import 'data/repositories/currency_repository.dart';
import 'data/repositories/expense_repository.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/currency_update/currency_update_bloc.dart';
import 'presentation/blocs/expense_list/expense_list_bloc.dart';
import 'presentation/pages/login_screen/login_screen.dart';

/// Root widget of the application
/// Configures bloc providers and theme
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ExpenseRepository>(
          create: (context) => sl<ExpenseRepository>(),
        ),
        RepositoryProvider<CurrencyRepository>(
          create: (context) => sl<CurrencyRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ExpenseListBloc>(
            create: (context) => sl<ExpenseListBloc>()
              ..add(const ExpenseListSubscriptionRequested()),
          ),
          BlocProvider<CurrencyUpdateBloc>(
            create: (context) => sl<CurrencyUpdateBloc>(),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => sl<AuthBloc>(),
          ),
        ],
        child: MaterialApp(
          home: const LoginScreen(),
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
