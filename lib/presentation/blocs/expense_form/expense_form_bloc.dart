import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_tracking/domain/entities/category.dart';
import 'package:expense_tracking/domain/entities/expense.dart';
import 'package:expense_tracking/domain/usecases/create_or_update_expense_use_case.dart';

part 'expense_form_event.dart';
part 'expense_form_state.dart';

/// Bloc for managing an expense form. It updates fields and submits the expense using the domain use case.
class ExpenseFormBloc extends Bloc<ExpenseFormEvent, ExpenseFormState> {
  ExpenseFormBloc({
    required CreateOrUpdateExpenseUseCase createOrUpdateExpenseUseCase,
    Expense? initialExpense,
  })  : _createOrUpdateExpenseUseCase = createOrUpdateExpenseUseCase,
        super(
          ExpenseFormState(
            initialExpense: initialExpense,
            title: initialExpense?.title,
            amount: initialExpense?.amount,
            date: initialExpense?.date ?? DateTime.now(),
            category: initialExpense?.category ?? Category.other,
            currency: initialExpense?.currency ?? 'USD',
          ),
        ) {
    on<ExpenseTitleChanged>(_onTitleChanged);
    on<ExpenseAmountChanged>(_onAmountChanged);
    on<ExpenseDateChanged>(_onDateChanged);
    on<ExpenseCategoryChanged>(_onCategoryChanged);
    on<ExpenseSubmitted>(_onSubmitted);
  }
  final CreateOrUpdateExpenseUseCase _createOrUpdateExpenseUseCase;

  void _onTitleChanged(
    ExpenseTitleChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onAmountChanged(
    ExpenseAmountChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    final amount = double.tryParse(event.amount) ?? 0.0;
    emit(state.copyWith(amount: amount));
  }

  void _onDateChanged(
    ExpenseDateChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(date: event.date));
  }

  void _onCategoryChanged(
    ExpenseCategoryChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(category: event.category));
  }

  Future<void> _onSubmitted(
    ExpenseSubmitted event,
    Emitter<ExpenseFormState> emit,
  ) async {
    final expense = state.initialExpense?.copyWith(
          title: state.title,
          amount: state.amount,
          date: state.date,
          category: state.category,
          currency: state.currency,
        ) ??
        Expense(
          id: const Uuid().v4(),
          title: state.title ?? '',
          amount: state.amount ?? 0.0,
          date: state.date,
          category: state.category,
          currency: state.currency,
        );

    emit(state.copyWith(status: ExpenseFormStatus.loading));

    try {
      await _createOrUpdateExpenseUseCase.execute(expense);
      emit(state.copyWith(status: ExpenseFormStatus.success));
      // Reset form state after success
      emit(ExpenseFormState(date: DateTime.now()));
    } catch (e) {
      emit(state.copyWith(status: ExpenseFormStatus.failure));
    }
  }
}
