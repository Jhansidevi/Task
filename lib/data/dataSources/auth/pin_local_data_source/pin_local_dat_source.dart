import 'package:shared_preferences/shared_preferences.dart';

abstract class PinLocalDataSource {
  Future<void> savePin(String pin);
  Future<bool> verifyPin(String pin);
  Future<bool> isPinSet();
}

class PinLocalDataSourceImpl implements PinLocalDataSource {
  static const String _pinKey = 'user_app_pin';

  @override
  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
  }

  @override
  Future<bool> verifyPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString(_pinKey);
    return savedPin == pin;
  }

  @override
  Future<bool> isPinSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_pinKey);
  }
}


