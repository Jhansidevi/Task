import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/usecases/transaction/transaction_use_cases.dart';
part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionUseCases useCases;

  TransactionBloc({required this.useCases}) : super(TransactionInitial()) {

    on<LoadAllTransactionsEvent>((event, emit) async {
      emit(TransactionLoading());
      try {
        final transactions = await useCases.getAllTransactions();
        final now = DateTime.now();
        final initialMonth = DateTime(now.year, now.month);

        // Filter transactions for the initial month
        final filteredTransactions = _filterByMonth(transactions, initialMonth);

        emit(TransactionLoaded(
          transactions: transactions,
          filteredTransactions: filteredTransactions,
          selectedMonth: initialMonth,
        ));
      } catch (e) {
        emit(TransactionError("Failed to load transactions"));
      }
    });

    on<UpdateSelectedMonthEvent>((event, emit) {
      if (state is TransactionLoaded) {
        final currentState = state as TransactionLoaded;

        final filteredTransactions = _filterByMonth(currentState.transactions, event.selectedMonth);

        emit(currentState.copyWith(
          selectedMonth: event.selectedMonth,
          filteredTransactions: filteredTransactions,
        ));
      }
    });
  }

  // Helper method to filter transactions by month/year
  List<TransactionEntity> _filterByMonth(
      List<TransactionEntity> transactions,
      DateTime monthToFilter,
      ) {
    return transactions.where((txn) {
      final formatter = DateFormat('dd/MM/yyyy');
      DateTime txnDate = formatter.parse(txn.date); // assuming txn.date is DateTime
      return txnDate.year == monthToFilter.year && txnDate.month == monthToFilter.month;
    }).toList();
  }
}

