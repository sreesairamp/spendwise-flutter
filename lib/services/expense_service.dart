import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class ExpenseService {
  static const String _storageKey = 'spendwise_expenses';

  /// Load persisted expenses from SharedPreferences
  Future<List<Expense>> loadExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final List<dynamic> decodedList = jsonDecode(jsonString) as List<dynamic>;
      return decodedList
          .map((item) => Expense.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Save expenses list to SharedPreferences
  Future<bool> saveExpenses(List<Expense> expenses) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonString =
          jsonEncode(expenses.map((e) => e.toJson()).toList());
      return await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      return false;
    }
  }
}
