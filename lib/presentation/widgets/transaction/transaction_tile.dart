import 'package:flutter/material.dart';
import '../../../domain/entities/transaction_entity.dart';

class TransactionTile extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    IconData leadingIcon;
    Color iconColor;
    switch (transaction.category) {
      case 'Shopping':
        bgColor = Color(0xFFFFEDD6);
        leadingIcon = Icons.shopping_bag;
        iconColor = Color(0xFFF69409);
        break;
      case 'Subscription':
        bgColor = Color(0xFFF5F1FE);
        leadingIcon = Icons.menu_book;
        iconColor = Color(0xFF9263DD);
        break;
      case 'Food':
        bgColor = Color(0xFFFFE5E5);
        leadingIcon = Icons.restaurant;
        iconColor = Color(0xFFE0494A);
        break;
      default:
        bgColor = Colors.grey[200]!;
        leadingIcon = Icons.category;
        iconColor = Colors.black;
        break;
    }

    final color = transaction.type == TransactionType.income
        ? Color(0xFF169B50)
        : Color(0xFFE0494A);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(17),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(leadingIcon, color: iconColor, size: 26),
        ),
        title: Text(
          transaction.title,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        subtitle: Text(
          transaction.title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${transaction.type == TransactionType.income ? '+ ' : '- '}₹${transaction.amount.toStringAsFixed(0)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
            SizedBox(height: 2),
            Text(
              transaction.date,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
