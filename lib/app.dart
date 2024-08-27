import 'package:expense_tracking/blocs/auth/auth_bloc.dart';

import 'blocs/currency_update/currency_update_bloc.dart';
import 'blocs/expense_list/expense_list_bloc.dart';
import 'network_services/dio_service_manager.dart';
import 'network_services/iservice_manager.dart';
import 'pages/login_screen/login_screen.dart';
import 'repositories/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key, required this.expenseRepository});

  final ExpenseRepository expenseRepository;

  @override
  Widget build(BuildContext context) {
    final IserviceManager serviceManager = DioServiceManager();

    return RepositoryProvider.value(
      value: expenseRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ExpenseListBloc>(
            create: (context) => ExpenseListBloc(
              repository: expenseRepository,
            )..add(const ExpenseListSubscriptionRequested()),
          ),
          BlocProvider<CurrencyUpdateBloc>(
            create: (context) => CurrencyUpdateBloc(
              repository: expenseRepository,
              serviceManager: serviceManager, // Use the interface type
            ),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(),
          )
        ],
        child: MaterialApp(
          home: LoginScreen(expenseRepository: expenseRepository),
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
