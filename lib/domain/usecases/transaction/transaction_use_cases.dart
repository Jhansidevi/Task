import '../../../data/repositories/transaction/transaction_repository.dart';
import '../../entities/transaction_entity.dart';

class GetAllTransactionsUseCase {
  final TransactionRepository repository;

  GetAllTransactionsUseCase(this.repository);

  Future<List<TransactionEntity>> call() {
    return repository.getAllTransactions();
  }
}

class TransactionUseCases {
  final GetAllTransactionsUseCase getAllTransactions;

  TransactionUseCases({
    required this.getAllTransactions,
  });
}
