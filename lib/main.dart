import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_goal_task/presentation/bloc/auth/pin_event.dart';
import 'package:sky_goal_task/presentation/pages/auth/pin_screen.dart';
import 'core/service_locator/auth_service_locator.dart' as di;
import 'presentation/bloc/auth/pin_bloc.dart';
import 'presentation/pages/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PinBloc>(
      create: (_) => di.sl<PinBloc>()..add(InitPinCheck()),
      child: MaterialApp(
        title: 'Task',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/pin': (context) => const PinScreen(),
          // Add other routes here
        },
      ),
    );
  }
}
