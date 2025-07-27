import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_goal_task/core/service_locator/transaction_sl.dart';
import 'package:sky_goal_task/data/dataSources/auth/pin_local_data_source/pin_local_dat_source.dart';
import '../../data/repositories/auth/pin_repository.dart';
import '../../domain/repositories/auth/pin_repository_impl.dart';
import '../../domain/usecases/auth/pin_use_cases.dart';
import '../../presentation/bloc/auth/pin_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  transactionsSlInit();
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<PinLocalDataSource>(
        () => PinLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<PinRepository>(
        () => PinRepositoryImpl(storage: sl()),
  );

  sl.registerLazySingleton(() => SavePinUseCase(sl()));
  sl.registerLazySingleton(() => ValidatePinUseCase(sl()));
  sl.registerLazySingleton(() => IsPinSetUseCase(sl()));

  sl.registerFactory(() => PinBloc(
    savePin: sl(),
    validatePin: sl(),
    isPinSet: sl(),
  ));
}

