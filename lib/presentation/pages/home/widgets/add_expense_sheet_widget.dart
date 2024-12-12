import 'package:expense_tracking/domain/entities/category.dart';
import 'package:expense_tracking/presentation/blocs/currency_update/currency_update_bloc.dart';
import 'package:expense_tracking/presentation/blocs/expense_form/expense_form_bloc.dart';
import 'package:expense_tracking/presentation/widgets/loading_widget.dart';
import 'package:expense_tracking/presentation/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddExpenseSheetWidget extends StatelessWidget {
  const AddExpenseSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.viewInsetsOf(context),
      child: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleFieldWidget(),
            SizedBox(height: 16),
            AmountFieldWidget(),
            SizedBox(height: 16),
            DateFieldWidget(),
            SizedBox(height: 24),
            CategoryChoicesWidget(),
            SizedBox(height: 30),
            AddButtonWidget(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class AddButtonWidget extends StatelessWidget {
  const AddButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ExpenseFormBloc>().state;
    final isLoading = state.status == ExpenseFormStatus.loading;

    return FilledButton(
      onPressed: isLoading || !state.isFormValid
          ? null
          : () {
              context.read<ExpenseFormBloc>().add(ExpenseSubmitted());
              Navigator.pop(context);
            },
      child: isLoading ? const LoadingWidget() : const Text('Add Expense'),
    );
  }
}

class DateFieldWidget extends StatelessWidget {
  const DateFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bloc = context.read<ExpenseFormBloc>();
    final state = context.watch<ExpenseFormBloc>().state;

    final formattedDate = DateFormat('dd/MM/yyyy').format(
      state.initialExpense?.date ?? state.date,
    );

    return GestureDetector(
      onTap: () async {
        final today = DateTime.now();
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: state.date,
          firstDate: DateTime(1900),
          lastDate: DateTime(today.year + 50),
        );
        if (selectedDate != null) {
          bloc.add(ExpenseDateChanged(selectedDate));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Date',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.4),
              height: 1,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Text(formattedDate, style: textTheme.titleLarge),
        ],
      ),
    );
  }
}

class AmountFieldWidget extends StatelessWidget {
  const AmountFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ExpenseFormBloc>().state;
    final currencyState = context.watch<CurrencyUpdateBloc>().state;

    // Get the correct currency symbol
    final currencySymbol = _getCurrencySymbol(currencyState.currency);

    return TextFormFieldWidget(
      label: 'Amount',
      hint: '0.00',
      prefixText: currencySymbol,
      enabled: state.status != ExpenseFormStatus.loading,
      initialValue: state.initialExpense?.amount.toString(),
      onChanged: (value) {
        context.read<ExpenseFormBloc>().add(ExpenseAmountChanged(value));
      },
    );
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'EUR':
        return '€';
      case 'TRY':
        return '₺';
      case 'USD':
      default:
        return r'$';
    }
  }
}

class TitleFieldWidget extends StatelessWidget {
  const TitleFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.watch<ExpenseFormBloc>().state;

    return TextFormField(
      style: textTheme.displaySmall?.copyWith(fontSize: 30),
      onChanged: (value) {
        context.read<ExpenseFormBloc>().add(ExpenseTitleChanged(value));
      },
      initialValue: state.initialExpense?.title,
      decoration: InputDecoration(
        enabled: state.status != ExpenseFormStatus.loading,
        border: InputBorder.none,
        hintText: 'Expense Title',
      ),
    );
  }
}

class CategoryChoicesWidget extends StatelessWidget {
  const CategoryChoicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bloc = context.read<ExpenseFormBloc>();
    final state = context.watch<ExpenseFormBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Select Category',
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.4),
            height: 1,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: Category.values
              .where((category) => category != Category.all)
              .map(
                (currentCategory) => ChoiceChip(
                  label: Text(currentCategory.toName),
                  selected: currentCategory == state.category,
                  onSelected: (_) => bloc.add(
                    ExpenseCategoryChanged(currentCategory),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
