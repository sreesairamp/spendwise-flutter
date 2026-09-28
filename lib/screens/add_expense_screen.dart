import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final ValueChanged<Expense> onAddExpense;

  const AddExpenseScreen({
    super.key,
    required this.onAddExpense,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  bool _isPaid = false;

  final List<String> _categories = [
    'Food',
    'Shopping',
    'Bills',
    'Transport',
    'Entertainment',
    'Other',
  ];

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final merchant = _merchantController.text.trim();
      final amount = double.parse(_amountController.text.trim());

      final newExpense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        merchant: merchant,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        isPaid: _isPaid,
        isApiSample: false,
      );

      widget.onAddExpense(newExpense);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expense for "$merchant" saved successfully!'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Reset form
      _formKey.currentState?.reset();
      _merchantController.clear();
      _amountController.clear();
      setState(() {
        _selectedCategory = 'Food';
        _selectedDate = DateTime.now();
        _isPaid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formattedDate = DateFormat('EEEE, MMM dd, yyyy').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Expense',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAlignment: CrossAlignment.start,
            children: [
              Text(
                'New Expense Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16.0),

              // Merchant Name Field
              TextFormField(
                controller: _merchantController,
                decoration: InputDecoration(
                  labelText: 'Merchant Name',
                  hintText: 'e.g. Starbucks, Target, Netflix',
                  prefixIcon: const Icon(Icons.storefront_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a merchant name.';
                  }
                  if (value.trim().length < 2) {
                    return 'Merchant name must be at least 2 characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount (\$)',
                  hintText: '0.00',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount.';
                  }
                  final parsedAmount = double.tryParse(value.trim());
                  if (parsedAmount == null) {
                    return 'Please enter a valid number.';
                  }
                  if (parsedAmount <= 0) {
                    return 'Amount must be greater than \$0.00.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16.0),

              // Date Picker Selector
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(16.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: theme.textTheme.bodyMedium,
                      ),
                      Icon(
                        Icons.edit_calendar_outlined,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Mark as Paid Switch Tile
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                title: const Text('Mark as Paid/Completed'),
                subtitle: const Text('Toggle payment completion status'),
                value: _isPaid,
                onChanged: (value) {
                  setState(() {
                    _isPaid = value;
                  });
                },
                activeColor: colorScheme.primary,
              ),

              const SizedBox(height: 28.0),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 54.0,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Save Expense',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
