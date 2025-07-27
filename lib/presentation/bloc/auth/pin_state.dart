enum PinStage { setup, confirm, enter }

class PinState {
  final PinStage stage;
  final String enteredPin;
  final String firstPin;
  final String error;
  final bool success;

  PinState({
    required this.stage,
    this.enteredPin = '',
    this.firstPin = '',
    this.error = '',
    this.success = false,
  });

  PinState copyWith({
    PinStage? stage,
    String? enteredPin,
    String? firstPin,
    String? error,
    bool? success,
  }) {
    return PinState(
      stage: stage ?? this.stage,
      enteredPin: enteredPin ?? this.enteredPin,
      firstPin: firstPin ?? this.firstPin,
      error: error ?? '',
      success: success ?? false,
    );
  }
}
