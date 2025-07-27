part of 'transaction_bloc.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions; // full data (all transactions)
  final List<TransactionEntity> filteredTransactions; // filtered based on selectedMonth
  final DateTime selectedMonth;

  TransactionLoaded({
    required this.transactions,
    required this.filteredTransactions,
    required this.selectedMonth,
  });

  TransactionLoaded copyWith({
    List<TransactionEntity>? transactions,
    List<TransactionEntity>? filteredTransactions,
    DateTime? selectedMonth,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }
}



class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);
}
