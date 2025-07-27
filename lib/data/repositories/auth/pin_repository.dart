abstract class PinRepository {
  Future<void> savePin(String pin);
  Future<bool> validatePin(String pin);
  Future<bool> isPinSet();
}


