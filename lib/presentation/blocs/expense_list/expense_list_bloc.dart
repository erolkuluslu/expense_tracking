import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracking/domain/entities/category.dart';
import 'package:expense_tracking/domain/entities/expense.dart';
import 'package:expense_tracking/domain/usecases/delete_expense_use_case.dart';
import 'package:expense_tracking/domain/usecases/get_all_expenses_use_case.dart';
import 'package:expense_tracking/presentation/blocs/expense_list/expense_list_event.dart';

part 'expense_list_state.dart';

/// BLoC that manages a list of expenses.
///
/// PURPOSE:
/// - Load all expenses from a repository (via a use case).
/// - Delete expenses on user request.
/// - Filter expenses by category.
///
/// FLOW OVERVIEW:
/// STEP#1: On subscription requested, start listening to a stream of expenses from use case.
/// STEP#2: Update state as expenses arrive.
/// STEP#3: When delete event arrives, remove that expense and update state.
/// STEP#4: Filter events change the displayed category.

class ExpenseListBloc extends Bloc<ExpenseListEvent, ExpenseListState> {
  ExpenseListBloc({
    required GetAllExpensesUseCase getAllExpensesUseCase,
    required DeleteExpenseUseCase deleteExpenseUseCase,
  })  : _getAllExpensesUseCase = getAllExpensesUseCase,
        _deleteExpenseUseCase = deleteExpenseUseCase,
        super(const ExpenseListState()) {
    // STEP#1: On subscription requested, listen for updates.
    on<ExpenseListSubscriptionRequested>(_onSubscriptionRequested);

    // STEP#2: When user wants to delete an expense, handle it.
    on<ExpenseListExpenseDeleted>(_onExpenseDeleted);

    // STEP#3: When user changes category filter, update the filter in state.
    on<ExpenseListCategoryFilterChanged>(_onExpenseCategoryFilterChanged);
  }
  final GetAllExpensesUseCase _getAllExpensesUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;

  Future<void> _onSubscriptionRequested(
    ExpenseListSubscriptionRequested event,
    Emitter<ExpenseListState> emit,
  ) async {
    // Indicate loading while we set up the stream
    emit(state.copyWith(status: () => ExpenseListStatus.loading));

    // STEP#1: Get a stream of expenses from domain layer.
    final stream = _getAllExpensesUseCase.execute();

    // STEP#2: "forEach" will listen to stream updates and rebuild UI states.
    await emit.forEach<List<Expense?>>(
      stream,
      onData: (expenses) => state.copyWith(
        status: () => ExpenseListStatus.success,
        expenses: () => expenses,
        // Calculate total by summing all expense amounts
        totalExpenses: () =>
            expenses.map((e) => e?.amount ?? 0.0).fold(0, (a, b) => a + b),
      ),
      onError: (_, __) => state.copyWith(
        status: () => ExpenseListStatus.failure,
      ),
    );
  }

  Future<void> _onExpenseDeleted(
    ExpenseListExpenseDeleted event,
    Emitter<ExpenseListState> emit,
  ) async {
    // STEP#3: Use the domain use case to delete the specified expense by ID
    try {
      await _deleteExpenseUseCase.execute(event.expense.id);
      // After deletion, the stream listener will automatically update the state with new expenses.
    } catch (error) {
      // If something goes wrong during deletion, set status to failure or handle error gracefully.
      emit(state.copyWith(status: () => ExpenseListStatus.failure));
    }
  }

  Future<void> _onExpenseCategoryFilterChanged(
    ExpenseListCategoryFilterChanged event,
    Emitter<ExpenseListState> emit,
  ) async {
    // STEP#4: Update the filter in state so UI can show filtered expenses.
    emit(state.copyWith(filter: () => event.filter));
  }
}
