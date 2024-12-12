// ignore: directives_ordering
import 'package:expense_tracking/core/di/service_locator.dart';
import 'package:expense_tracking/core/theme/theme.dart';
import 'package:expense_tracking/data/repositories/currency_repository_impl.dart';
import 'package:expense_tracking/domain/repositories/expense_repository.dart';
import 'package:expense_tracking/presentation/blocs/auth/auth_bloc.dart';
import 'package:expense_tracking/presentation/blocs/currency_update/currency_update_bloc.dart';
import 'package:expense_tracking/presentation/blocs/expense_list/expense_list_bloc.dart';
import 'package:expense_tracking/presentation/pages/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IExpenseRepository>(
          create: (context) => sl<IExpenseRepository>(),
        ),
        RepositoryProvider<CurrencyRepositoryImpl>(
          create: (context) => sl<CurrencyRepositoryImpl>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ExpenseListBloc>(
            create: (context) => sl<ExpenseListBloc>(),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => sl<AuthBloc>(),
          ),
          BlocProvider<CurrencyUpdateBloc>(
            create: (context) => sl<CurrencyUpdateBloc>(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              ThemeMode.dark, // Automatically switch based on system settings
          title: 'Expense Tracker',
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
