import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/custom_button.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/textfield.dart';
import 'package:lingora/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lingora/features/auth/presentation/cubit/auth_state.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Success
        if (state.status == AuthAppStatus.success && context.mounted) {
          context.go('/translate');
        }
        // Error
        else if (state.status == AuthAppStatus.error) {
          final message =
              authErrorMessages[state.errorType] ?? 'error_words_title'.tr();

          showSnackBar(
            context,
            message: message,
            icon: HeroIcons.informationCircle,
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
                  child: Lottie.asset("assets/animation/space_man.json")),

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

              // Forget password ?
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'forgot_password'.tr(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),

              SizedBox(
                height: AppDimens.sectionBetween,
              ),

              LayoutBuilder(builder: (context, _) {
                // Login
                Widget loginButton = BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    bool isLoading = state.status == AuthAppStatus.loading;
                    return CustomButton(
                        isLoading: isLoading,
                        text: 'login_button'.tr(),
                        color: Theme.of(context).colorScheme.primary,
                        function: () {
                          context.read<AuthCubit>().login(
                              emailController.text, passwordController.text);
                        },
                        textColor: Colors.white);
                  },
                );
                // Google
                Widget googleButton = // Google
                    CustomButton(
                        text: 'login_with_google'.tr(),
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.1)),
                        function: () {},
                        textColor:
                            Theme.of(context).textTheme.bodyMedium?.color);

                if (AppPlatform.isPhone(context)) {
                  return Column(
                    children: [
                      loginButton,
                      SizedBox(
                        height: AppDimens.sectionSpacing,
                      ),
                      googleButton
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: googleButton),
                      SizedBox(
                        width: AppDimens.buttonTagHorizontal,
                      ),
                      Expanded(child: loginButton),
                    ],
                  );
                }
              }),

              SizedBox(
                height: AppDimens.sectionBetween,
              ),
              // Don't have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'no_account'.tr(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(
                    width: AppDimens.elementBetween,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go('/register');
                    },
                    child: Text(
                      'signup_button'.tr(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
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
