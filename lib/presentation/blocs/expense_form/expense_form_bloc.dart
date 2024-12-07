/// Bloc for managing expense form state and handling expense creation/editing
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import 'package:uuid/uuid.dart';

import '../../../data/models/category.dart';
import '../../../data/models/expense.dart';
import '../../../data/repositories/expense_repository.dart';

part 'expense_form_event.dart';
part 'expense_form_state.dart';

/// [ExpenseFormBloc] manages the state of the expense form
/// Handles creating new expenses and editing existing ones
class ExpenseFormBloc extends Bloc<ExpenseFormEvent, ExpenseFormState> {
  /// Creates an instance of [ExpenseFormBloc]
  /// [repository] is used for expense persistence
  /// [initialExpense] is provided when editing an existing expense
  ExpenseFormBloc({
    required ExpenseRepository repository,
    Expense? initialExpense,
  })  : _repository = repository,
        super(ExpenseFormState(
          initialExpense: initialExpense,
          title: initialExpense?.title,
          amount: initialExpense?.amount,
          date: initialExpense?.date ?? DateTime.now(),
          category: initialExpense?.category ?? Category.other,
          currency: initialExpense?.currency ?? 'USD', // Initialize currency
        )) {
    on<ExpenseTitleChanged>(_onTitleChanged);
    on<ExpenseAmountChanged>(_onAmountChanged);
    on<ExpenseDateChanged>(_onDateChanged);
    on<ExpenseCategoryChanged>(_onCategoryChanged);
    on<ExpenseSubmitted>(_onSubmitted);
  }

  final ExpenseRepository _repository;

  /// Handles changes to the expense title
  void _onTitleChanged(
    ExpenseTitleChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  /// Handles changes to the expense amount
  /// Parses the string amount to double
  void _onAmountChanged(
    ExpenseAmountChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    final amount = double.parse(event.amount);
    emit(state.copyWith(amount: amount));
  }

  /// Handles changes to the expense date
  void _onDateChanged(
    ExpenseDateChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(date: event.date));
  }

  /// Handles changes to the expense category
  void _onCategoryChanged(
    ExpenseCategoryChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(category: event.category));
  }

  /// Handles form submission
  /// Creates a new expense or updates an existing one
  Future<void> _onSubmitted(
    ExpenseSubmitted event,
    Emitter<ExpenseFormState> emit,
  ) async {
    final expense = (state.initialExpense)?.copyWith(
          title: state.title,
          amount: state.amount,
          date: state.date,
          category: state.category,
          currency: state.currency, // Ensure currency is copied
        ) ??
        Expense(
          id: const Uuid().v4(),
          title: state.title!,
          amount: state.amount!,
          date: state.date,
          category: state.category,
          currency: state.currency, // Ensure new expenses have currency
        );

    emit(state.copyWith(status: ExpenseFormStatus.loading));

    try {
      await _repository.createExpense(expense);
      emit(state.copyWith(status: ExpenseFormStatus.success));
      emit(ExpenseFormState(date: DateTime.now()));
    } catch (e) {
      emit(state.copyWith(status: ExpenseFormStatus.failure));
    }
  }
}
