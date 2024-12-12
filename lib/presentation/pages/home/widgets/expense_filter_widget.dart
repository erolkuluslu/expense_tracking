// Use domain category instead of data category
import 'package:expense_tracking/domain/entities/category.dart';
import 'package:expense_tracking/presentation/blocs/expense_list/expense_list_bloc.dart';
import 'package:expense_tracking/presentation/blocs/expense_list/expense_list_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseFilterWidget extends StatelessWidget {
  const ExpenseFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const categories = Category.values;

    final activeFilter = context.select(
      (ExpenseListBloc bloc) => bloc.state.filter,
    );

    return LimitedBox(
      maxHeight: 40,
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = categories[index];

          return ChoiceChip(
            label: Text(category.toName),
            selected: activeFilter == category,
            onSelected: (_) => context
                .read<ExpenseListBloc>()
                .add(ExpenseListCategoryFilterChanged(category)),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: categories.length,
      ),
    );
  }
}
