import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracking/domain/entities/category.dart';
import 'package:expense_tracking/domain/entities/expense.dart';
import 'package:expense_tracking/domain/usecases/delete_expense_use_case.dart';
import 'package:expense_tracking/domain/usecases/get_all_expenses_use_case.dart';
import 'package:expense_tracking/presentation/blocs/expense_list/expense_list_event.dart';

part 'expense_list_state.dart';

/// Bloc that manages a list of expenses.
/// It uses domain use cases to load and delete expenses.
class ExpenseListBloc extends Bloc<ExpenseListEvent, ExpenseListState> {
  ExpenseListBloc({
    required GetAllExpensesUseCase getAllExpensesUseCase,
    required DeleteExpenseUseCase deleteExpenseUseCase,
  })  : _getAllExpensesUseCase = getAllExpensesUseCase,
        _deleteExpenseUseCase = deleteExpenseUseCase,
        super(const ExpenseListState()) {
    on<ExpenseListSubscriptionRequested>(_onSubscriptionRequested);
    on<ExpenseListExpenseDeleted>(_onExpenseDeleted);
    on<ExpenseListCategoryFilterChanged>(_onExpenseCategoryFilterChanged);
  }
  final GetAllExpensesUseCase _getAllExpensesUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;

  Future<void> _onSubscriptionRequested(
    ExpenseListSubscriptionRequested event,
    Emitter<ExpenseListState> emit,
  ) async {
    emit(state.copyWith(status: () => ExpenseListStatus.loading));

    final stream = _getAllExpensesUseCase.execute();

    await emit.forEach<List<Expense?>>(
      stream,
      onData: (expenses) => state.copyWith(
        status: () => ExpenseListStatus.success,
        expenses: () => expenses,
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
    await _deleteExpenseUseCase.execute(event.expense.id);
  }

  Future<void> _onExpenseCategoryFilterChanged(
    ExpenseListCategoryFilterChanged event,
    Emitter<ExpenseListState> emit,
  ) async {
    emit(state.copyWith(filter: () => event.filter));
  }
}
