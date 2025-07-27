import 'dart:io';
import 'package:file_picker/file_picker.dart';

class AddTransactionFormState {
  final String amount;
  final String description;
  final String? category;
  final String? wallet;
  final File? pickedImage;
  final PlatformFile? pickedDocument;
  final bool repeat;
  final bool isValid;

  AddTransactionFormState({
    this.amount = "",
    this.description = "",
    this.category,
    this.wallet,
    this.pickedImage,
    this.pickedDocument,
    this.repeat = false,
    this.isValid = false,
  });

  AddTransactionFormState copyWith({
    String? amount,
    String? description,
    String? category,
    String? wallet,
    File? pickedImage,
    PlatformFile? pickedDocument,
    bool? repeat,
    bool? isValid,
  }) {
    return AddTransactionFormState(
      amount: amount ?? this.amount,
      description: description ?? this.description,
      category: category ?? this.category,
      wallet: wallet ?? this.wallet,
      pickedImage: pickedImage ?? this.pickedImage,
      pickedDocument: pickedDocument ?? this.pickedDocument,
      repeat: repeat ?? this.repeat,
      isValid: isValid ?? this.isValid,
    );
  }
}
