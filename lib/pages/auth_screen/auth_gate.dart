import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/pages/auth_screen/login.dart';
import 'package:lingora/pages/nav.dart';
import 'package:lingora/pages/onboarding/onboarding_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthAppCubit, AuthAppState>(
        buildWhen: (prev, curr) {
          final shouldBuild = curr.status == AuthAppStatus.checkingSession ||
              curr.status == AuthAppStatus.authenticated ||
              curr.status == AuthAppStatus.unauthenticated;

          print("UI buildWhen =============================== $shouldBuild");
          return shouldBuild;
        },
        builder: (context, state) {
          print("UI WORKING  ===============================");
          if (state.status == AuthAppStatus.checkingSession) {
            print("UI LOADING  ===============================");
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                strokeWidth: 4,
              ),
            );
          } else if (state.status == AuthAppStatus.authenticated) {
            print("UI NAV  ===============================");
            return const OnboardingScreen(); // Todo change it later
          } else {
            print("UI LOGIN   ===============================");
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
