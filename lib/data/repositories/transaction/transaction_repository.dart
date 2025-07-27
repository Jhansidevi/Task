import 'package:sky_goal_task/data/models/transaction/transaction_model.dart';
import 'package:sky_goal_task/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getAllTransactions();
}
