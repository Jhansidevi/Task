import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/transaction_entity.dart';
import '../../bloc/transaction/transaction_bloc.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key});

  DateTime parseDate(String dateStr) => DateFormat('dd/MM/yyyy').parse(dateStr);

  bool _isSameDay(DateTime d1, DateTime d2) =>
      d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;

  String getDisplayDateLabel(DateTime date, DateTime today) {
    if (_isSameDay(date, today)) return "Today";
    if (_isSameDay(date, today.subtract(const Duration(days: 1)))) return "Yesterday";
    return DateFormat("dd MMM, yyyy").format(date);
  }

  List<TransactionEntity> filterTransactionsByMonth(
      List<TransactionEntity> transactions,
      DateTime selectedMonth) {
    return transactions.where((txn) {
      final txnDate = parseDate(txn.date);
      return txnDate.year == selectedMonth.year && txnDate.month == selectedMonth.month;
    }).toList();
  }

  Map<DateTime, List<TransactionEntity>> groupTransactionsByDate(List<TransactionEntity> transactions) {
    final Map<DateTime, List<TransactionEntity>> grouped = {};
    for (final txn in transactions) {
      final txnDate = parseDate(txn.date);
      final dateKey = DateTime(txnDate.year, txnDate.month, txnDate.day);
      grouped.putIfAbsent(dateKey, () => []).add(txn);
    }
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return {for (var k in sortedKeys) k: grouped[k]!};
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> months = List.generate(
      12,
          (i) => DateTime(DateTime.now().year, i + 1),
    );

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            DateTime selectedMonth = DateTime.now();
            if (state is TransactionLoaded) {
              selectedMonth = state.selectedMonth;
            }

            return PopupMenuButton<DateTime>(
              initialValue: selectedMonth,
              onSelected: (newMonth) {
                context.read<TransactionBloc>().add(UpdateSelectedMonthEvent(newMonth));
              },
              itemBuilder: (context) => months.map((month) {
                return PopupMenuItem<DateTime>(
                  value: month,
                  child: Text(DateFormat('MMMM yyyy').format(month)),
                );
              }).toList(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('MMMM yyyy').format(selectedMonth),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            );
          },
        ),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TransactionError) {
            return Center(child: Text(state.message));
          }
          if (state is TransactionLoaded) {
            final today = DateTime.now();
            final filteredTransactions = filterTransactionsByMonth(state.transactions, state.selectedMonth);
            final groupedTransactions = groupTransactionsByDate(filteredTransactions);

            if (groupedTransactions.isEmpty) {
              return const Center(
                child: Text(
                  "No transactions available for this month.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                final dateKey = groupedTransactions.keys.elementAt(index);
                final txnsForDate = groupedTransactions[dateKey]!;

                final dateLabel = getDisplayDateLabel(dateKey, today);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                      child: Text(
                        dateLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: txnsForDate.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final txn = txnsForDate[i];
                        final isIncome = txn.type == TransactionType.income;

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(12), // adjust radius as needed
                          ),
                          clipBehavior: Clip.antiAlias, // clips ListTile's ripple effect within rounded corners
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isIncome ? Colors.green[100] : Colors.red[100],
                              child: Icon(
                                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                            ),
                            title: Text(txn.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(
                              txn.category,
                              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            ),
                            trailing: Text(
                              "${isIncome ? '+' : '-'}₹${txn.amount.toStringAsFixed(0)}",
                              style: TextStyle(
                                color: isIncome ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
