import '../../data/dataSources/transaction/transaction_local_data_source/transaction_local_data_source.dart';
import '../../data/repositories/transaction/transaction_repository.dart';
import '../../domain/repositories/transactions/transaction_repo_impl.dart';
import '../../domain/usecases/transaction/transaction_use_cases.dart';
import 'auth_service_locator.dart';

Future<void> transactionsSlInit() async {
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      localDataSource: sl.get<TransactionLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetAllTransactionsUseCase>(
    () => GetAllTransactionsUseCase(sl.get<TransactionRepository>()),
  );

  sl.registerLazySingleton<TransactionUseCases>(
    () => TransactionUseCases(
      getAllTransactions: sl.get<GetAllTransactionsUseCase>(),
    ),
  );
}
