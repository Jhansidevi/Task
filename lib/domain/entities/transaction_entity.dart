enum TransactionType { income, expense }

class TransactionEntity {
  final String id;
  final String title;
  final String category;
  final double amount;
  final String date;
  final TransactionType type;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
  });
}
