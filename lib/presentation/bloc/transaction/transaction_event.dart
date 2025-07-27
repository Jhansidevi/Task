part of 'transaction_bloc.dart';

abstract class TransactionEvent {}

class LoadAllTransactionsEvent extends TransactionEvent {}

class UpdateSelectedMonthEvent extends TransactionEvent {
  final DateTime selectedMonth;
  UpdateSelectedMonthEvent(this.selectedMonth);
}
