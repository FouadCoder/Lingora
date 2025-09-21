import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/pages/login.dart';
import 'package:lingora/pages/nav.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({
    super.key,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthAppCubit>().launch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthAppCubit, AuthAppState>(
      builder: (context, state) {
        if (state.status == AuthAppStatus.success) {
          return Nav();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
