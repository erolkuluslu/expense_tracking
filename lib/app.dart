import 'package:expense_tracking/blocs/currency_update/currency_update_bloc.dart';
import 'package:expense_tracking/blocs/expense_list/expense_list_bloc.dart';
import 'package:expense_tracking/network_services/dio_service_manager.dart';
import 'package:expense_tracking/network_services/iservice_manager.dart';
import 'package:expense_tracking/repositories/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/home/home_page.dart';
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
        ],
        child: MaterialApp(
          home: const HomePage(),
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
