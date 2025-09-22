import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/widgets/app_container.dart';
import 'package:lingora/widgets/custom_button.dart';
import 'package:lingora/widgets/flushbar.dart';
import 'package:lingora/widgets/textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  final Map<AuthErrorType, String> authErrorMessages = {
    AuthErrorType.emptyData: 'error_empty_data'.tr(),
    AuthErrorType.invalidEmail: 'error_invalid_email'.tr(),
    AuthErrorType.shortPassword: 'error_short_password'.tr(),
    AuthErrorType.wrongConfirmPassword: 'error_wrong_confirm_password'.tr(),
    AuthErrorType.noInternet: 'error_no_internet'.tr(),
    AuthErrorType.wrongPassword: 'error_wrong_password'.tr(),
    AuthErrorType.accountExists: 'error_account_exists'.tr(),
  };

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthAppCubit, AuthAppState>(
      listener: (context, state) {
        // Success
        if (state.status == AuthAppStatus.success && context.mounted) {
          context.go('/signup_success');
        }
        // Error
        else if (state.status == AuthAppStatus.error) {
          final message =
              authErrorMessages[state.errorType] ?? 'error_words_title'.tr();

          showSnackBar(
            context,
            message: message,
            icon: Icons.error_outline,
            iconColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: AppContainer(
            child: SingleChildScrollView(
          child: Column(
            children: [
              // App Logo
              SizedBox(
                height: AppPlatform.isPhone(context)
                    ? MediaQuery.of(context).size.height * 0.20
                    : 300,
                width: AppPlatform.isPhone(context)
                    ? MediaQuery.of(context).size.width
                    : 300,
                child: Image.asset(
                  'assets/logo/lingora_logo.png',
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),

              SizedBox(
                height: AppDimens.sectionBetween,
              ),

              // Email
              CustomTextfield(
                controller: emailController,
                hint: 'email_hint'.tr(),
                label: 'email_label'.tr(),
                prefixIcon: Icon(Icons.email),
              ),

              SizedBox(
                height: AppDimens.sectionSpacing,
              ),

              // Password
              CustomTextfield(
                  controller: passwordController,
                  hint: 'password_hint'.tr(),
                  label: 'password_label'.tr(),
                  prefixIcon: Icon(
                    Icons.shield,
                  )),
              SizedBox(
                height: AppDimens.sectionSpacing,
              ),

              CustomTextfield(
                  controller: confirmPasswordController,
                  hint: 'confirm_password_hint'.tr(),
                  label: 'confirm_password_label'.tr(),
                  prefixIcon: Icon(
                    Icons.shield,
                  )),

              SizedBox(
                height: AppDimens.sectionBetween,
              ),

              // Sign up Button
              BlocBuilder<AuthAppCubit, AuthAppState>(
                builder: (context, state) {
                  bool isLoading = state.status == AuthAppStatus.loading;
                  return CustomButton(
                      text: 'signup_button'.tr(),
                      isLoading: isLoading,
                      color: Theme.of(context).colorScheme.secondary,
                      function: () {
                        context.read<AuthAppCubit>().signUp(
                            emailController.text,
                            passwordController.text,
                            confirmPasswordController.text);
                      },
                      textColor: Colors.white);
                },
              ),
              // I Love you 🖤 :)
              //* I love you more :)

              SizedBox(
                height: AppDimens.sectionSpacing,
              ),

              // Google
              CustomButton(
                  text: 'signup_with_google'.tr(),
                  color: Colors.transparent,
                  border: Border.all(
                      width: 2, color: Theme.of(context).colorScheme.outline),
                  function: () {},
                  textColor: Colors.white),

              SizedBox(
                height: AppDimens.sectionBetween,
              ),
              // Don't have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'have_account'.tr(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(
                    width: AppDimens.elementBetween,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go('/login');
                    },
                    child: Text(
                      'login_button'.tr(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
