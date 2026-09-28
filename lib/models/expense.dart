class Expense {
  final String id;
  final String merchant;
  final double amount;
  final String category;
  final DateTime date;
  final bool isPaid;
  final bool isApiSample;

  const Expense({
    required this.id,
    required this.merchant,
    required this.amount,
    required this.category,
    required this.date,
    this.isPaid = false,
    this.isApiSample = false,
  });

  Expense copyWith({
    String? id,
    String? merchant,
    double? amount,
    String? category,
    DateTime? date,
    bool? isPaid,
    bool? isApiSample,
  }) {
    return Expense(
      id: id ?? this.id,
      merchant: merchant ?? this.merchant,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      isPaid: isPaid ?? this.isPaid,
      isApiSample: isApiSample ?? this.isApiSample,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchant': merchant,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'isPaid': isPaid,
      'isApiSample': isApiSample,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      merchant: json['merchant'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      isPaid: json['isPaid'] as bool? ?? false,
      isApiSample: json['isApiSample'] as bool? ?? false,
    );
  }
}
