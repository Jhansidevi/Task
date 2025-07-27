import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/pin_use_cases.dart';
import 'pin_event.dart';
import 'pin_state.dart';

class PinBloc extends Bloc<PinEvent, PinState> {
  final SavePinUseCase savePin;
  final ValidatePinUseCase validatePin;
  final IsPinSetUseCase isPinSet;

  PinBloc({
    required this.savePin,
    required this.validatePin,
    required this.isPinSet,
  }) : super(PinState(stage: PinStage.setup)) {
    on<InitPinCheck>(_onInit);
    on<EnterPinDigit>(_onEnterDigit);
    on<DeleteLastDigit>(_onDeleteDigit);
    on<SubmitPin>(_onSubmitPin);
  }

  void _onInit(InitPinCheck event, Emitter<PinState> emit) async {
    final isSet = await isPinSet();
    emit(state.copyWith(stage: isSet ? PinStage.enter : PinStage.setup));
  }

  void _onEnterDigit(EnterPinDigit event, Emitter<PinState> emit) {
    if (state.enteredPin.length < 4) {
      emit(state.copyWith(
        enteredPin: state.enteredPin + event.digit,
        error: '',
      ));
    }
  }

  void _onDeleteDigit(DeleteLastDigit event, Emitter<PinState> emit) {
    if (state.enteredPin.isNotEmpty) {
      emit(state.copyWith(
        enteredPin: state.enteredPin.substring(0, state.enteredPin.length - 1),
        error: '',
      ));
    }
  }

  void _onSubmitPin(SubmitPin event, Emitter<PinState> emit) async {
    if (state.enteredPin.length != 4) return;

    switch (state.stage) {
      case PinStage.setup:
        emit(state.copyWith(
          stage: PinStage.confirm,
          firstPin: state.enteredPin,
          enteredPin: '',
        ));
        break;

      case PinStage.confirm:
        if (state.enteredPin == state.firstPin) {
          await savePin(state.enteredPin);
          emit(state.copyWith(success: true));
        } else {
          emit(state.copyWith(
            error: "PINs do not match",
            enteredPin: '',
          ));
        }
        break;

      case PinStage.enter:
        final valid = await validatePin(state.enteredPin);
        if (valid) {
          emit(state.copyWith(success: true));
        } else {
          emit(state.copyWith(
            error: "Incorrect PIN",
            enteredPin: '',
          ));
        }
        break;
    }
  }
}
