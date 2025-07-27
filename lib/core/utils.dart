import 'package:intl/intl.dart';
import '../domain/entities/transaction_entity.dart';


bool isToday(DateTime date) {
  final now = DateTime.now();
  return now.year == date.year && now.month == date.month && now.day == date.day;
}

bool isThisWeek(DateTime date) {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(Duration(days: 6));
  return !date.isBefore(startOfWeek) && !date.isAfter(endOfWeek);
}

bool isThisMonth(DateTime date) {
  final now = DateTime.now();
  return now.year == date.year && now.month == date.month;
}

bool isThisYear(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year;
}

String getDisplayDate(DateTime txnDate, DateTime today) {
  if (isSameDay(txnDate, today)) return "Today";
  if (isSameDay(txnDate, today.subtract(Duration(days: 1)))) return "Yesterday";
  return DateFormat("dd MMM, yyyy").format(txnDate);
}

bool isSameDay(DateTime d1, DateTime d2) =>
    d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;

List<TransactionEntity> filterTransactionsByPeriod(
    List<TransactionEntity> transactions,
    String period,
    DateTime selectedDate,
    ) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  bool isSameDay(DateTime d1, DateTime d2) =>
      d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;

  bool isSameWeek(DateTime d1, DateTime d2) {
    DateTime mondayOfWeek(DateTime d) => d.subtract(Duration(days: d.weekday - 1));
    final start1 = mondayOfWeek(d1);
    final start2 = mondayOfWeek(d2);
    return isSameDay(start1, start2);
  }

  bool isSameMonth(DateTime d1, DateTime d2) => d1.year == d2.year && d1.month == d2.month;

  bool isSameYear(DateTime d1, DateTime d2) => d1.year == d2.year;

  return transactions.where((txn) {
    final txnDate = formatter.parse(txn.date);  // parse the string date here

    switch (period) {
      case 'Today':
        return isSameDay(txnDate, selectedDate);
      case 'Week':
        return isSameWeek(txnDate, selectedDate);
      case 'Month':
        return isSameMonth(txnDate, selectedDate);
      case 'Year':
        return isSameYear(txnDate, selectedDate);
      default:
        return true;
    }
  }).toList();
}

