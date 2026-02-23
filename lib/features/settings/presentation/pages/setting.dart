import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/header.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/custom_swtich.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:lingora/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lingora/features/auth/presentation/cubit/auth_state.dart';
import 'package:lingora/features/history/presentation/cubit/history_cubit.dart';
import 'package:lingora/features/notification/presentation/cubit/notifications/notification_cubit.dart';
import 'package:lingora/features/notification/presentation/cubit/reminders/reminder_cubit.dart';
import 'package:lingora/features/settings/presentation/cubit/language_cubit.dart';
import 'package:lingora/features/settings/presentation/cubit/language_state.dart';
import 'package:lingora/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:lingora/features/settings/presentation/cubit/theme_state.dart';
import 'package:lingora/features/settings/presentation/widgets/account.dart';
import 'package:lingora/features/settings/presentation/widgets/language_switcher.dart';
import 'package:lingora/features/translate/presentation/cubit/translate_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/favorites/favorites_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/notes/notes_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final ValueNotifier<bool> darkController = ValueNotifier(false);
  final ValueNotifier<bool> notificationsController = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    context.read<ThemeCubit>().getTheme();
  }

  @override
  void dispose() {
    darkController.dispose();
    notificationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // success
        if (state.status == AuthAppStatus.success && context.mounted) {
          // Reset ALL user data cubits
          context.read<TranslateCubit>().reset();
          context.read<LibraryCubit>().reset();
          context.read<NotesCubit>().reset();
          context.read<AnalyticsCubit>().reset();
          context.read<HistoryCubit>().reset();
          context.read<FavoritesCubit>().reset();
          context.read<NotificationCubit>().reset();
          context.read<ReminderCubit>().reset();
          context.read<AuthCubit>().reset();
          context.read<LevelCubit>().reset();
          context.go('/login');
        }

        // Error
        else if (state.status == AuthAppStatus.error) {
          showSnackBar(
            context,
            message: 'error_words_title'.tr(),
            icon: HeroIcons.exclamationTriangle,
            iconColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return Scaffold(
            body: AppContainer(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  // Setting
                  AppCard(
                    child: Column(
                      children: [
                        Header(
                            icon: HeroIcons.cog6Tooth, title: "settings".tr()),
                        SizedBox(
                          height: AppDimens.titleContentBetween,
                        ),
                        BlocBuilder<ThemeCubit, ThemeState>(
                          builder: (context, state) {
                            darkController.value = state == ThemeState.dark;
                            return CustomSwtich(
                              title: 'dark_mode'.tr(),
                              description: 'dark_mode_description'.tr(),
                              onChanged: (value) {
                                context.read<ThemeCubit>().setTheme(
                                    value ? ThemeState.dark : ThemeState.light);
                              },
                              controller: darkController,
                            );
                          },
                        ),

                        SizedBox(
                          height: AppDimens.sectionSpacing,
                        ),

                        // Language
                        LanguageSwitcher()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppDimens.sectionSpacing,
                  ),
                  // Aaccount
                  AccountWidget()
                ],
              ),
            )),
          );
        },
      ),
    );
  }
}
