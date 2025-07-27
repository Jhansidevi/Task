import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../cubit/add_transaction/add_transaction_cubit.dart';
import '../../cubit/add_transaction/add_transaction_state.dart';
import '../../widgets/transaction/editable_amount_widget.dart';

class AddTransactionScreen extends StatelessWidget {
  final bool isExpense;
  const AddTransactionScreen({super.key, this.isExpense = true});

  @override
  Widget build(BuildContext context) {
    final color = isExpense ? Color(0xFFE0494A) : Color(0xFF169B50);

    return BlocProvider(
      create: (_) => AddTransactionFormCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: color,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
          title: Text(isExpense ? 'Expense' : 'Income',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          centerTitle: true,
        ),
        body: BlocBuilder<AddTransactionFormCubit, AddTransactionFormState>(
          builder: (context, state) {
            final cubit = context.read<AddTransactionFormCubit>();

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  color: color,
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 14),
                  child: EditableAmountWidget(
                    amountCtrl: TextEditingController(text: state.amount)
                      ..selection = TextSelection.collapsed(offset: state.amount.length),
                    onChanged: (val) => cubit.amountChanged(val),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: state.category,
                          items: ['Subscription', 'Food', 'Utilities']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          decoration: InputDecoration(labelText: 'Category'),
                          onChanged: cubit.categoryChanged,
                        ),
                        SizedBox(height: 7),
                        TextFormField(
                          initialValue: state.description,
                          decoration: InputDecoration(labelText: 'Description'),
                          onChanged: cubit.descriptionChanged,
                        ),
                        SizedBox(height: 7),
                        DropdownButtonFormField<String>(
                          value: state.wallet,
                          items: ['Paypal', 'Main Wallet', 'Cash']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          decoration: InputDecoration(labelText: 'Wallet'),
                          onChanged: cubit.walletChanged,
                        ),
                        SizedBox(height: 14),
                        // Attachment button
                        GestureDetector(
                          onTap: () => _showAttachmentOptions(context, cubit),
                          child: AbsorbPointer(
                            child: OutlinedButton.icon(
                              icon: Icon(Icons.attachment, color: Colors.black,),
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                side: BorderSide(color: Colors.black)
                              ),
                              label: Text('Add attachment', style: TextStyle(color: Colors.black),),
                              onPressed: null,
                            ),
                          ),
                        ),

                        if (state.pickedImage != null) ...[
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      state.pickedImage!,
                                      height: 85,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: cubit.clearPickedImage,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.grey.shade200,
                                      child:
                                      Icon(Icons.close, color: Colors.black87, size: 16),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                        if (state.pickedDocument != null) ...[
                          SizedBox(height: 10),
                          Stack(
                            children: [
                              Container(
                                height: 85,
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade100,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.insert_drive_file, size: 40),
                                      Text(
                                        state.pickedDocument!.name,
                                        style: TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: cubit.clearPickedDocument,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.grey.shade200,
                                    child: Icon(Icons.close, color: Colors.black87, size: 16),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Repeat", style: TextStyle(fontWeight: FontWeight.w600)),
                            Switch(
                                value: state.repeat,
                                activeColor: color,
                                onChanged: cubit.repeatChanged),
                          ],
                        ),
                        SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state.isValid
                                ? () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      height: 100,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check_circle, color: Colors.purple),
                                          SizedBox(height: 10),
                                          Text("Transaction has been successfully added"),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              state.isValid ? Color(0xFF9263DD) : Colors.grey.shade400,
                              minimumSize: Size(0, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                              textStyle:
                              TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                            ),
                            child: Text("Continue", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context, AddTransactionFormCubit cubit) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Container(
          height: 200,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () async {
                      final img = await ImagePicker().pickImage(source: ImageSource.camera);
                      if (img != null) {
                        cubit.pickedImageChanged(File(img.path));
                      }
                      Navigator.pop(context);
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.image,
                    label: 'Image',
                    onTap: () async {
                      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (img != null) {
                        cubit.pickedImageChanged(File(img.path));
                      }
                      Navigator.pop(context);
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.insert_drive_file,
                    label: 'Document',
                    onTap: () async {
                      final result = await FilePicker.platform.pickFiles(type: FileType.any);
                      if (result != null && result.files.isNotEmpty) {
                        cubit.pickedDocumentChanged(result.files.first);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.purple.shade100,
          border: Border.all(color: Colors.purple.shade100),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.black),
            SizedBox(height: 8),
            Text(label, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
