import '../../../data/repositories/auth/pin_repository.dart';

class SavePinUseCase {
  final PinRepository repo;

  SavePinUseCase(this.repo);

  Future<void> call(String pin) => repo.savePin(pin);
}

class ValidatePinUseCase {
  final PinRepository repo;

  ValidatePinUseCase(this.repo);

  Future<bool> call(String pin) => repo.validatePin(pin);
}

class IsPinSetUseCase {
  final PinRepository repo;

  IsPinSetUseCase(this.repo);

  Future<bool> call() => repo.isPinSet();
}



