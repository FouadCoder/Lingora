import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/status/network_error_status.dart';
import 'package:lingora/features/notification/presentation/cubit/reminders/reminder_cubit.dart';
import 'package:lingora/features/notification/presentation/cubit/reminders/reminder_state.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/core/widgets/custom_swtich.dart';

class ReminderSwitchWidget extends StatefulWidget {
  final WordEntity word;

  const ReminderSwitchWidget({
    super.key,
    required this.word,
  });

  @override
  State<ReminderSwitchWidget> createState() => _ReminderSwitchWidgetState();
}

class _ReminderSwitchWidgetState extends State<ReminderSwitchWidget> {
  bool activeNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        BlocListener<ReminderCubit, ReminderState>(
          listener: (context, state) {
            // success
            if (state.actionStatus == ReminderStatus.success) {
              showSnackBar(
                context,
                message: 'reminder_set_success'.tr(),
                icon: HeroIcons.checkCircle,
                iconColor: Colors.green,
              );
            }

            // error
            else if (state.actionStatus == ReminderStatus.error) {
              showSnackBar(
                context,
                message: 'reminder_set_error'.tr(),
                icon: HeroIcons.exclamationTriangle,
                iconColor: Colors.red,
              );
            } else if (state.actionStatus == ReminderStatus.networkError) {
              showErrorNetworkSnackBar(context);
            }
          },
          child: CustomSwtich(
            title: 'reminders_title'.tr(),
            description: activeNotifications
                ? 'reminders_active'.tr()
                : 'reminders_inactive'.tr(),
            onChanged: (value) {
              setState(() {
                activeNotifications = value;
              });
              if (activeNotifications) {
                context.read<ReminderCubit>().activeReminder(widget.word);
              }
            },
            controller: ValueNotifier(activeNotifications),
            icon: activeNotifications ? HeroIcons.bell : HeroIcons.bellSlash,
          ),
        ),
      ],
    );
  }
}
