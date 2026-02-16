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
  final void Function(WordEntity updatedWord)? onReminderChange;

  const ReminderSwitchWidget({
    super.key,
    required this.word,
    this.onReminderChange,
  });

  @override
  State<ReminderSwitchWidget> createState() => _ReminderSwitchWidgetState();
}

class _ReminderSwitchWidgetState extends State<ReminderSwitchWidget> {
  late bool isOptimisticReminder;

  @override
  void initState() {
    super.initState();
    isOptimisticReminder = widget.word.activeReminder;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        BlocListener<ReminderCubit, ReminderState>(
          listener: (context, state) {
            // success
            if (state.actionStatus == ReminderStatus.success) {
              // Call the callback if provided with the updated word from state
              if (state.word != null) {
                widget.onReminderChange?.call(state.word!);
              }

              showSnackBar(
                context,
                message: 'reminder_set_success'.tr(),
                icon: HeroIcons.checkCircle,
                iconColor: Colors.green,
              );
            }

            // error
            else if (state.actionStatus == ReminderStatus.error) {
              setState(() {
                isOptimisticReminder = !isOptimisticReminder;
              });
              showSnackBar(
                context,
                message: 'reminder_set_error'.tr(),
                icon: HeroIcons.exclamationTriangle,
                iconColor: Colors.red,
              );
            } else if (state.actionStatus == ReminderStatus.networkError) {
              setState(() {
                isOptimisticReminder = !isOptimisticReminder;
              });
              showErrorNetworkSnackBar(context);
            }
          },
          child: CustomSwtich(
            title: 'reminders_title'.tr(),
            description: isOptimisticReminder
                ? 'reminders_active'.tr()
                : 'reminders_inactive'.tr(),
            onChanged: (value) {
              setState(() {
                isOptimisticReminder = value;
              });
              if (isOptimisticReminder) {
                context.read<ReminderCubit>().activeReminder(widget.word);
              }
            },
            controller: ValueNotifier(isOptimisticReminder),
            icon: isOptimisticReminder ? HeroIcons.bell : HeroIcons.bellSlash,
          ),
        ),
      ],
    );
  }
}
