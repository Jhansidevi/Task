import 'package:flutter/material.dart';
import 'package:sky_goal_task/presentation/pages/profile/security_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Currency'),
            trailing: const Text('INR'),  // Example
            onTap: () { /* Navigate to Currency screen */ },
          ),
          ListTile(
            title: const Text('Theme'),
            trailing: const Text('Light'),  // Example
            onTap: () { /* Navigate to Theme screen */ },
          ),
          ListTile(
            title: const Text('Security'),
            trailing: const Text('Pin'),  // Example
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecurityScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () { /* Navigate to About screen */ },
          ),
          ListTile(
            title: const Text('Help'),
            onTap: () { /* Navigate to Help screen */ },
          ),
        ],
      ),
    );
  }
}
