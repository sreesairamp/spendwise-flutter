import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/summary_card.dart';
import '../widgets/expense_card.dart';
import '../widgets/error_view.dart';

class HomeScreen extends StatelessWidget {
  final List<Expense> allExpenses;
  final List<Expense> apiExpenses;
  final bool isLoadingApi;
  final String? apiError;
  final VoidCallback onRetryApi;
  final VoidCallback onNavigateToAdd;
  final ValueChanged<Expense> onDeleteExpense;
  final ValueChanged<Expense> onTogglePaid;

  const HomeScreen({
    super.key,
    required this.allExpenses,
    required this.apiExpenses,
    required this.isLoadingApi,
    required this.apiError,
    required this.onRetryApi,
    required this.onNavigateToAdd,
    required this.onDeleteExpense,
    required this.onTogglePaid,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double totalExpenses = allExpenses.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );

    final recentTransactions = allExpenses.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'SpendWise',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh API Data',
            onPressed: onRetryApi,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Summary Card
            SummaryCard(
              totalExpenses: totalExpenses,
              transactionCount: allExpenses.length,
            ),
            const SizedBox(height: 24.0),

            // REST API Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'JSONPlaceholder Sample Data',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                if (isLoadingApi)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 8.0),

            // API Loading / Error / Banner State
            if (isLoadingApi && apiExpenses.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Fetching JSONPlaceholder API sample data...'),
                    ],
                  ),
                ),
              )
            else if (apiError != null && apiExpenses.isEmpty)
              ErrorView(
                errorMessage: apiError!,
                onRetry: onRetryApi,
              )
            else if (apiExpenses.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.cloud_done_outlined,
                      color: colorScheme.secondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Loaded ${apiExpenses.length} sample expenses from REST API.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24.0),

            // Quick Add Expense CTA Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        Text(
                          'Track New Expense',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Keep your budget up to date effortlessly.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: onNavigateToAdd,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Expense'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24.0),

            // Recent Transactions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${recentTransactions.length} of ${allExpenses.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            if (recentTransactions.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: Text(
                    'No expenses recorded yet. Tap "Add Expense" to begin.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentTransactions.length,
                itemBuilder: (context, index) {
                  final expense = recentTransactions[index];
                  return ExpenseCard(
                    expense: expense,
                    onDelete: () => onDeleteExpense(expense),
                    onTogglePaid: (_) => onTogglePaid(expense),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
