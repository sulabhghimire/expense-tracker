import 'package:expense/widgets/chart/chart.dart';
import 'package:expense/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import 'package:expense/models/expense.dart';

import 'expenses_list/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesSate();
  }
}

class _ExpensesSate extends State<Expenses> {
  final List<Expense> _recordedExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) =>
            NewExpense(expenseHandler: _addExpenses));
  }

  void _addExpenses(Expense expense) {
    setState(() {
      _recordedExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _recordedExpenses.indexOf(expense);
    setState(() {
      _recordedExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text('Expense Deleted!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _recordedExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width);
    final height = (MediaQuery.of(context).size.height);

    Widget mainContent = const Center(
      child: Text('No Expenses found, Start Adding some!'),
    );

    if (_recordedExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _recordedExpenses, removeExpenseHandler: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _recordedExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _recordedExpenses)),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
