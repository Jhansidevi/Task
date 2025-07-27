import '../../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
   TransactionModel({
    required super.id,
    required super.title,
    required super.category,
    required super.amount,
    required super.date,
    required super.type,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      amount: json['amount'],
      date: (json['date']),
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'amount': amount,
    'date': date,
    'type': type.name,
  };
}