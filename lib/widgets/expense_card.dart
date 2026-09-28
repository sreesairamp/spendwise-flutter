import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onDelete;
  final ValueChanged<bool?>? onTogglePaid;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.onDelete,
    this.onTogglePaid,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_outlined;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'bills':
        return Icons.receipt_long_outlined;
      case 'transport':
        return Icons.directions_car_outlined;
      case 'entertainment':
        return Icons.movie_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  Color _getCategoryColor(BuildContext context, String category) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'shopping':
        return Colors.purple;
      case 'bills':
        return Colors.redAccent;
      case 'transport':
        return Colors.blue;
      case 'entertainment':
        return Colors.teal;
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formattedDate = DateFormat('MMM dd, yyyy').format(expense.date);
    final categoryColor = _getCategoryColor(context, expense.category);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Category Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(expense.category),
                color: categoryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12.0),

            // Merchant & Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          expense.merchant,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: expense.isPaid
                                ? TextDecoration.lineThrough
                                : null,
                            color: expense.isPaid
                                ? colorScheme.onSurface.withValues(alpha: 0.5)
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (expense.isApiSample)
                        Container(
                          margin: const EdgeInsets.only(left: 6.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'API',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        expense.category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '•',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        formattedDate,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount & Status
            Column(
              crossAxisAlignment: CrossAlignment.end,
              children: [
                Text(
                  '-\$${expense.amount.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: expense.isPaid
                        ? colorScheme.outline
                        : colorScheme.error,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Paid toggle checkbox / chip
                    InkWell(
                      onTap: () {
                        onTogglePaid?.call(!expense.isPaid);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: expense.isPaid
                              ? Colors.green.withValues(alpha: 0.15)
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              expense.isPaid
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              size: 14,
                              color: expense.isPaid
                                  ? Colors.green.shade700
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              expense.isPaid ? 'Paid' : 'Pending',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: expense.isPaid
                                    ? Colors.green.shade700
                                    : colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (onDelete != null) ...[
                      const SizedBox(width: 4.0),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: colorScheme.error.withValues(alpha: 0.8),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: onDelete,
                        tooltip: 'Delete expense',
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
