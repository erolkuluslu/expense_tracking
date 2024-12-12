import 'package:expense_tracking/core/di/service_locator.dart';
import 'package:expense_tracking/domain/entities/expense.dart';
import 'package:expense_tracking/domain/usecases/create_or_update_expense_use_case.dart';
// Assuming you have your service locator (sl) set up correctly:
import 'package:expense_tracking/presentation/blocs/expense_form/expense_form_bloc.dart';
import 'package:expense_tracking/presentation/pages/home/widgets/add_expense_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension AppX on BuildContext {
  Future<void> showAddExpenseSheet({Expense? expense}) {
    return showModalBottomSheet(
      context: this,
      builder: (context) => BlocProvider(
        // Provide the ExpenseFormBloc with the required use case:
        create: (context) => ExpenseFormBloc(
          initialExpense: expense,
          createOrUpdateExpenseUseCase: sl<CreateOrUpdateExpenseUseCase>(),
        ),
        child: const AddExpenseSheetWidget(),
      ),
      isScrollControlled: true,
      useRootNavigator: true,
      showDragHandle: true,
    );
  }
}
