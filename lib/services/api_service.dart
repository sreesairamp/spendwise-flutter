import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense.dart';

class ApiService {
  static const String _endpoint =
      'https://jsonplaceholder.typicode.com/posts?_limit=5';

  /// Fetches sample items from JSONPlaceholder API and converts them to Expense models
  Future<List<Expense>> fetchSampleExpenses() async {
    try {
      final response = await http
          .get(Uri.parse(_endpoint))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
        final List<String> sampleCategories = [
          'Food',
          'Shopping',
          'Bills',
          'Transport',
          'Entertainment'
        ];

        return List.generate(jsonList.length, (index) {
          final item = jsonList[index] as Map<String, dynamic>;
          final rawTitle = item['title'] as String;
          
          // Format raw title into a clean merchant name
          final words = rawTitle.split(' ');
          final merchantName = words.take(3).join(' ');
          final capitalizedMerchant = merchantName.isEmpty
              ? 'Sample Merchant ${index + 1}'
              : merchantName[0].toUpperCase() + merchantName.substring(1);

          return Expense(
            id: 'api_${item['id']}',
            merchant: capitalizedMerchant,
            amount: (index + 1) * 23.50 + 14.99,
            category: sampleCategories[index % sampleCategories.length],
            date: DateTime.now().subtract(Duration(days: index + 1)),
            isPaid: index % 2 == 0,
            isApiSample: true,
          );
        });
      } else {
        throw Exception(
            'Failed to fetch sample data. Server returned HTTP ${response.statusCode}.');
      }
    } catch (e) {
      throw Exception('Network error: Unable to load sample data from REST API.');
    }
  }
}
