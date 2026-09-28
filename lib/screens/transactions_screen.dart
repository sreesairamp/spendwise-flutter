import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_card.dart';
import '../widgets/empty_state.dart';

class TransactionsScreen extends StatefulWidget {
  final List<Expense> expenses;
  final ValueChanged<Expense> onDeleteExpense;
  final ValueChanged<Expense> onTogglePaid;

  const TransactionsScreen({
    super.key,
    required this.expenses,
    required this.onDeleteExpense,
    required this.onTogglePaid,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Food',
    'Shopping',
    'Bills',
    'Transport',
    'Entertainment',
    'Other',
  ];

  List<Expense> get _filteredExpenses {
    return widget.expenses.where((expense) {
      final matchesSearch = expense.merchant
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' ||
          expense.category.toLowerCase() == _selectedCategory.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _confirmDelete(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text(
          'Are you sure you want to delete the expense for "${expense.merchant}" (\$${expense.amount.toStringAsFixed(2)})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onDeleteExpense(expense);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted expense "${expense.merchant}"'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filteredList = _filteredExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transactions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search merchant...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Category Chips Horizontal Scroll List
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8.0),

          // Transactions Count Sub-header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${filteredList.length} expenses',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_searchQuery.isNotEmpty || _selectedCategory != 'All')
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _selectedCategory = 'All';
                      });
                    },
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Reset filters'),
                  ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Expense ListView builder
          Expanded(
            child: filteredList.isEmpty
                ? EmptyState(
                    title: 'No transactions found',
                    message: _searchQuery.isNotEmpty || _selectedCategory != 'All'
                        ? 'Try adjusting your search query or category filter.'
                        : 'No expenses added yet. Tap "Add Expense" to get started.',
                    icon: Icons.search_off_rounded,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final expense = filteredList[index];
                      return ExpenseCard(
                        expense: expense,
                        onDelete: () => _confirmDelete(context, expense),
                        onTogglePaid: (_) => widget.onTogglePaid(expense),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
