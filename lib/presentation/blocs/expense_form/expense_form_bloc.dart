import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_tracking/domain/entities/category.dart';
import 'package:expense_tracking/domain/entities/expense.dart';
import 'package:expense_tracking/domain/usecases/create_or_update_expense_use_case.dart';

part 'expense_form_event.dart';
part 'expense_form_state.dart';

/// BLoC for managing an expense form (creating or editing an expense).
///
/// PURPOSE:
/// - Tracks form fields (title, amount, date, category, currency).
/// - Validates input (non-empty title, positive amount).
/// - On submission, tries to save expense via use case.
/// - Emits states to inform UI of success/failure/loading.
///
/// FLOW OVERVIEW:
/// STEP#1: Start with initial state (possibly with an initialExpense if editing).
/// STEP#2: When user changes title/amount/date/category, events are dispatched to update state.
/// STEP#3: On submission, validate. If invalid, emit failure.
/// STEP#4: If valid, save via use case and emit success.

class ExpenseFormBloc extends Bloc<ExpenseFormEvent, ExpenseFormState> {
  ExpenseFormBloc({
    required CreateOrUpdateExpenseUseCase createOrUpdateExpenseUseCase,
    Expense? initialExpense,
  })  : _createOrUpdateExpenseUseCase = createOrUpdateExpenseUseCase,
        // STEP#1: Initialize the state with existing expense data (if editing) or defaults.
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
    // STEP#2: Register event handlers for user input changes and submission.
    on<ExpenseTitleChanged>(_onTitleChanged);
    on<ExpenseAmountChanged>(_onAmountChanged);
    on<ExpenseDateChanged>(_onDateChanged);
    on<ExpenseCategoryChanged>(_onCategoryChanged);
    on<ExpenseSubmitted>(_onSubmitted);
  }

  final CreateOrUpdateExpenseUseCase _createOrUpdateExpenseUseCase;

  // HANDLER: When title changes
  void _onTitleChanged(
    ExpenseTitleChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    // Update the state with the new title
    emit(state.copyWith(title: event.title));
  }

  // HANDLER: When amount changes
  void _onAmountChanged(
    ExpenseAmountChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    // STEP#1: Try to parse the amount
    final amountString = event.amount.trim();
    final amount = double.tryParse(amountString);

    if (amount == null) {
      // STEP#2: If parsing fails, set status to failure and show error.
      emit(state.copyWith(
        amount: null,
        status: ExpenseFormStatus.failure,
        errorMessage: 'Invalid amount format',
      ));
    } else {
      // STEP#3: If parsing succeeds, reset to initial status, clear errors
      emit(state.copyWith(
        amount: amount,
        status: ExpenseFormStatus.initial,
        errorMessage: null,
      ));
    }
  }

  // HANDLER: When date changes
  void _onDateChanged(
    ExpenseDateChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    // Update state with the chosen date
    emit(state.copyWith(date: event.date));
  }

  // HANDLER: When category changes
  void _onCategoryChanged(
    ExpenseCategoryChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    // Update state with the chosen category
    emit(state.copyWith(category: event.category));
  }

  // HANDLER: When user submits the form
  Future<void> _onSubmitted(
    ExpenseSubmitted event,
    Emitter<ExpenseFormState> emit,
  ) async {
    // STEP#1: Validate title
    if (state.title == null || state.title!.trim().isEmpty) {
      emit(state.copyWith(
        status: ExpenseFormStatus.failure,
        errorMessage: 'Expense title cannot be empty',
      ));
      return;
    }

    // STEP#2: Validate amount
    if (state.amount == null || state.amount! <= 0) {
      emit(state.copyWith(
        status: ExpenseFormStatus.failure,
        errorMessage: 'Amount must be greater than zero',
      ));
      return;
    }

    // STEP#3: If valid, build or update the expense object
    final expense = state.initialExpense?.copyWith(
          title: state.title,
          amount: state.amount,
          date: state.date,
          category: state.category,
          currency: state.currency,
        ) ??
        Expense(
          id: const Uuid().v4(),
          title: state.title!,
          amount: state.amount!,
          date: state.date,
          category: state.category,
          currency: state.currency,
        );

    // STEP#4: Show loading state while saving
    emit(state.copyWith(status: ExpenseFormStatus.loading));

    try {
      // STEP#5: Use the domain use case to save the expense
      await _createOrUpdateExpenseUseCase.execute(expense);

      // STEP#6: On success, emit success state and clear any leftover error message.
      emit(state.copyWith(
          status: ExpenseFormStatus.success, errorMessage: null));

      // Optionally, you could reset the form here
      // emit(ExpenseFormState(date: DateTime.now()));
    } catch (e) {
      // STEP#7: If saving fails, emit failure and show error message.
      emit(state.copyWith(
        status: ExpenseFormStatus.failure,
        errorMessage: 'Failed to save expense: ${e.toString()}',
      ));
    }
  }
}
