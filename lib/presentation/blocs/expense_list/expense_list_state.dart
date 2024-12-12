part of 'expense_list_bloc.dart';

enum ExpenseListStatus { initial, loading, success, failure }

class ExpenseListState extends Equatable {
  const ExpenseListState({
    this.status = ExpenseListStatus.initial,
    this.expenses = const [],
    this.totalExpenses = 0.0,
    this.filter,
  });
  final ExpenseListStatus status;
  final List<Expense?> expenses;
  final double totalExpenses;
  final Category? filter;

  List<Expense?> get filteredExpenses {
    if (filter == null || filter == Category.all) {
      return expenses;
    }
    return expenses.where((expense) => expense?.category == filter).toList();
  }

  ExpenseListState copyWith({
    ExpenseListStatus Function()? status,
    List<Expense?> Function()? expenses,
    double Function()? totalExpenses,
    Category Function()? filter,
  }) {
    return ExpenseListState(
      status: status != null ? status() : this.status,
      expenses: expenses != null ? expenses() : this.expenses,
      totalExpenses:
          totalExpenses != null ? totalExpenses() : this.totalExpenses,
      filter: filter != null ? filter() : this.filter,
    );
  }

  @override
  List<Object?> get props => [status, expenses, totalExpenses, filter];
}
