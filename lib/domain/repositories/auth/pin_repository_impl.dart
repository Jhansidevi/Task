import '../../../data/dataSources/auth/pin_local_data_source/pin_local_dat_source.dart';
import '../../../data/repositories/auth/pin_repository.dart';

class PinRepositoryImpl implements PinRepository {
  final PinLocalDataSource storage;

  PinRepositoryImpl({required this.storage});

  @override
  Future<void> savePin(String pin) => storage.savePin(pin);

  @override
  Future<bool> validatePin(String pin) => storage.verifyPin(pin);

  @override
  Future<bool> isPinSet() => storage.isPinSet();

}

