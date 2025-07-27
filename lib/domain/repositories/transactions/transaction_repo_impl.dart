import 'package:sky_goal_task/domain/entities/transaction_entity.dart';
import '../../../data/dataSources/transaction/transaction_local_data_source/transaction_local_data_source.dart';
import '../../../data/repositories/transaction/transaction_repository.dart';
import '../../../data/models/transaction/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    final models = await localDataSource.getAllTransactions();
    return models.map((model) => TransactionEntity(
      id: model.id,
      title: model.title,
      category: model.category,
      amount: model.amount,
      date: model.date,
      type: model.type,
    )).toList();
  }
}
