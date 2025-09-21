import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/widgets/app_container.dart';
import 'package:lingora/widgets/custom_button.dart';
import 'package:lingora/widgets/textfield.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              height: AppDimens.cardInternal,
            ),

            // Password
            CustomTextfield(
                controller: passwordController,
                hint: 'password_label'.tr(),
                label: 'password_hint'.tr(),
                prefixIcon: Icon(
                  Icons.shield,
                )),

            SizedBox(
              height: AppDimens.cardInternal,
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

            // Login Button
            CustomButton(
                text: 'login_button'.tr(),
                color: Theme.of(context).colorScheme.secondary,
                function: () {},
                textColor: Colors.white),

            SizedBox(
              height: AppDimens.cardInternal,
            ),

            // Google
            CustomButton(
                text: 'login_with_google'.tr(),
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
                  'no_account'.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(
                  width: 2,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'signup_button'.tr(),
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
    );
  }
}
