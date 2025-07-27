import 'package:flutter/material.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  String _selected = 'PIN';

  void _showNotIntegratedSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Not integrated yet'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        children: [
          CustomRadioTile(
            label: 'PIN',
            value: 'PIN',
            groupValue: _selected,
            onChanged: (val) => setState(() => _selected = val),
          ),
          CustomRadioTile(
            label: 'Fingerprint',
            value: 'Fingerprint',
            groupValue: _selected,
            onChanged: (_) => _showNotIntegratedSnackbar(context),
            // Show as enabled so tap gets feedback, but selection does not change
          ),
          CustomRadioTile(
            label: 'Face ID',
            value: 'Face ID',
            groupValue: _selected,
            onChanged: (_) => _showNotIntegratedSnackbar(context),
          ),
        ],
      ),
    );
  }
}

class CustomRadioTile extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const CustomRadioTile({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.deepPurple : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: (_) => onChanged(value),
              activeColor: Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }
}
