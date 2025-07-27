import 'package:flutter/material.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../widgets/transaction/transaction_tile.dart';

class TransactionsSummaryScreen extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final String period;

  const TransactionsSummaryScreen({required this.transactions, required this.period, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All $period Transactions", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: transactions.isEmpty
          ? Center(child: Text("No Transactions"))
          : ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        itemCount: transactions.length,
        separatorBuilder: (_, __) => SizedBox(height: 10),
        itemBuilder: (context, index) =>
            TransactionTile(transaction: transactions[index]),
      ),
    );
  }
}
