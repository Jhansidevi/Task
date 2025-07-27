import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_goal_task/presentation/pages/home/home.dart';
import 'package:sky_goal_task/presentation/pages/main_screen.dart';
import '../../../core/service_locator/auth_service_locator.dart';
import '../../../domain/usecases/transaction/transaction_use_cases.dart';
import '../../bloc/auth/pin_bloc.dart';
import '../../bloc/auth/pin_event.dart';
import '../../bloc/auth/pin_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';

class PinScreen extends StatelessWidget {
  const PinScreen({super.key});

  String getHeading(PinStage stage) {
    switch (stage) {
      case PinStage.setup:
        return "Let's setup your PIN";
      case PinStage.confirm:
        return "Re-enter your PIN";
      case PinStage.enter:
        return "Enter your PIN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PinBloc, PinState>(
      listener: (context, state) {
        if (state.success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => TransactionBloc(useCases: sl<TransactionUseCases>()),
                child: const MainScreen(),
              ),
            ),
          );
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text("Success!")));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.deepPurple,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80,),
                Text(
                  getHeading(state.stage),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                        (i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: i < state.enteredPin.length
                            ? Colors.white
                            : Colors.white24,
                      ),
                    ),
                  ),
                ),
                if (state.error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(state.error,
                        style: TextStyle(color: Colors.redAccent)),
                  ),
                const Spacer(),
                _buildKeypad(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeypad(BuildContext context) {
    final bloc = context.read<PinBloc>();
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['del', '0', 'ok'],
    ];

    return Container(
      color: Colors.white,
      child: Column(
        children: keys.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              return TextButton(
                onPressed: () {
                  if (key == 'del') {
                    bloc.add(DeleteLastDigit());
                  } else if (key == 'ok') {
                    bloc.add(SubmitPin());
                  } else {
                    bloc.add(EnterPinDigit(key));
                  }
                },
                child: Text(
                  key == 'del'
                      ? '⌫'
                      : key == 'ok'
                      ? '✓'
                      : key,
                  style: TextStyle(fontSize: 24, color: Colors.black54),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
