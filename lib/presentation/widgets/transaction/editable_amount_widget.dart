import 'package:flutter/material.dart';

class EditableAmountWidget extends StatefulWidget {
  final TextEditingController amountCtrl;
  final TextStyle textStyle;
  final TextStyle labelStyle;
  final ValueChanged<String>? onChanged;

  const EditableAmountWidget({
    super.key,
    required this.amountCtrl,
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 38,
    ),
    this.labelStyle = const TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
    this.onChanged,
  });

  @override
  State<EditableAmountWidget> createState() => _EditableAmountWidgetState();
}

class _EditableAmountWidgetState extends State<EditableAmountWidget> {
  bool _isEditing = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // When focus lost, switch back to display mode
        setState(() {
          _isEditing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Text("How much?", style: widget.labelStyle),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: _isEditing
              ? TextField(
            onChanged: widget.onChanged,
            controller: widget.amountCtrl,
            focusNode: _focusNode,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: widget.textStyle,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              prefixText: '₹',
              prefixStyle: widget.textStyle,
            ),
            autofocus: true,
          )
              : GestureDetector(
            onTap: () {
              setState(() {
                _isEditing = true;
              });
              // Focus the text field after it rebuilds
              Future.delayed(Duration(milliseconds: 100), () {
                _focusNode.requestFocus();
              });
            },
            child: Text(
              "₹${widget.amountCtrl.text.isNotEmpty ? widget.amountCtrl.text : '0'}",
              style: widget.textStyle,
            ),
          ),
        ),
      ],
    );
  }
}
