import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lingora/features/auth/presentation/cubit/auth_state.dart';
import 'package:lingora/features/auth/presentation/pages/auth_screen/login.dart';
import 'package:lingora/features/auth/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:lingora/nav.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (prev, curr) {
          final shouldBuild = curr.status == AuthAppStatus.checkingSession ||
              curr.status == AuthAppStatus.authenticated ||
              curr.status == AuthAppStatus.unauthenticated;
          return shouldBuild;
        },
        builder: (context, state) {
          if (state.status == AuthAppStatus.checkingSession) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                strokeWidth: 4,
              ),
            );
          } else if (state.status == AuthAppStatus.authenticated) {
            return const Nav(
              isFullScreen: true,
            );
          } else if (state.status == AuthAppStatus.newUser) {
            return const OnboardingScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
