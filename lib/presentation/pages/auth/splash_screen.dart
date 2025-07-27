import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_goal_task/presentation/pages/auth/pin_screen.dart';
import '../../../core/service_locator/auth_service_locator.dart';
import '../../../domain/usecases/transaction/transaction_use_cases.dart';
import '../../bloc/transaction/transaction_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After 1 second, navigate to PIN screen (replace with your PIN screen route)
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacementNamed('/pin');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF894DFF),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glowing effect
            Container(
              width: 160,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.5),
                    blurRadius: 64,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            // App name
            const Text(
              "montra",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 44,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
