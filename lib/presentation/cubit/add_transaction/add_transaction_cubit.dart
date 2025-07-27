import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_transaction_state.dart';

class AddTransactionFormCubit extends Cubit<AddTransactionFormState> {
  AddTransactionFormCubit() : super(AddTransactionFormState());

  void amountChanged(String val) {
    _validateAndEmit(state.copyWith(amount: val));
  }

  void descriptionChanged(String val) {
    _validateAndEmit(state.copyWith(description: val));
  }

  void categoryChanged(String? val) {
    _validateAndEmit(state.copyWith(
      category: val,
    ));
  }

  void walletChanged(String? val) {
    _validateAndEmit(state.copyWith(wallet: val));
  }

  void pickedImageChanged(File? file) {
    // If image picked, clear document
    emit(state.copyWith(pickedImage: file, pickedDocument: null));
  }

  void pickedDocumentChanged(PlatformFile? document) {
    // If document picked, clear image
    emit(state.copyWith(pickedDocument: document, pickedImage: null));
  }

  void repeatChanged(bool val) {
    emit(state.copyWith(repeat: val));
  }

  void clearPickedImage() => emit(state.copyWith(pickedImage: null));
  void clearPickedDocument() => emit(state.copyWith(pickedDocument: null));

  void _validateAndEmit(AddTransactionFormState newState) {
    final isValid = _validateForm(newState);
    emit(newState.copyWith(isValid: isValid));
  }

  bool _validateForm(AddTransactionFormState s) {
    final amountValid = s.amount.trim().isNotEmpty && double.tryParse(s.amount) != null && double.parse(s.amount) > 0;
    final descriptionValid = s.description.trim().isNotEmpty;
    final categoryValid = s.category != null && s.category!.isNotEmpty;
    final walletValid = s.wallet != null && s.wallet!.isNotEmpty;
    return amountValid && descriptionValid && categoryValid && walletValid;
  }
}
