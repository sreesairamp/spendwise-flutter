import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'transactions_screen.dart';
import 'add_expense_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final ExpenseService _expenseService = ExpenseService();
  final ApiService _apiService = ApiService();

  List<Expense> _localExpenses = [];
  List<Expense> _apiExpenses = [];

  bool _isLoadingApi = false;
  String? _apiError;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadLocalExpenses();
    await _fetchApiExpenses();
  }

  Future<void> _loadLocalExpenses() async {
    final expenses = await _expenseService.loadExpenses();
    setState(() {
      _localExpenses = expenses;
    });
  }

  Future<void> _fetchApiExpenses() async {
    setState(() {
      _isLoadingApi = true;
      _apiError = null;
    });

    try {
      final sampleExpenses = await _apiService.fetchSampleExpenses();
      setState(() {
        _apiExpenses = sampleExpenses;
        _isLoadingApi = false;
      });
    } catch (e) {
      setState(() {
        _apiError = e.toString().replaceAll('Exception: ', '');
        _isLoadingApi = false;
      });
    }
  }

  Future<void> _handleAddExpense(Expense expense) async {
    setState(() {
      _localExpenses.insert(0, expense);
    });
    await _expenseService.saveExpenses(_localExpenses);
    // Switch tab to Transactions screen to view added expense
    setState(() {
      _currentIndex = 1;
    });
  }

  Future<void> _handleDeleteExpense(Expense expense) async {
    if (expense.isApiSample) {
      setState(() {
        _apiExpenses.removeWhere((e) => e.id == expense.id);
      });
    } else {
      setState(() {
        _localExpenses.removeWhere((e) => e.id == expense.id);
      });
      await _expenseService.saveExpenses(_localExpenses);
    }
  }

  Future<void> _handleTogglePaid(Expense expense) async {
    final updated = expense.copyWith(isPaid: !expense.isPaid);
    if (expense.isApiSample) {
      setState(() {
        final index = _apiExpenses.indexWhere((e) => e.id == expense.id);
        if (index != -1) {
          _apiExpenses[index] = updated;
        }
      });
    } else {
      setState(() {
        final index = _localExpenses.indexWhere((e) => e.id == expense.id);
        if (index != -1) {
          _localExpenses[index] = updated;
        }
      });
      await _expenseService.saveExpenses(_localExpenses);
    }
  }

  List<Expense> get _allExpenses => [..._localExpenses, ..._apiExpenses];

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        allExpenses: _allExpenses,
        apiExpenses: _apiExpenses,
        isLoadingApi: _isLoadingApi,
        apiError: _apiError,
        onRetryApi: _fetchApiExpenses,
        onNavigateToAdd: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        onDeleteExpense: _handleDeleteExpense,
        onTogglePaid: _handleTogglePaid,
      ),
      TransactionsScreen(
        expenses: _allExpenses,
        onDeleteExpense: _handleDeleteExpense,
        onTogglePaid: _handleTogglePaid,
      ),
      AddExpenseScreen(
        onAddExpense: _handleAddExpense,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Add Expense',
          ),
        ],
      ),
    );
  }
}
