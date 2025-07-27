abstract class PinEvent {}

class InitPinCheck extends PinEvent {}

class EnterPinDigit extends PinEvent {
  final String digit;
  EnterPinDigit(this.digit);
}

class DeleteLastDigit extends PinEvent {}

class SubmitPin extends PinEvent {}
