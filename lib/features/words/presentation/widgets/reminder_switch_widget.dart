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
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';

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
        BlocConsumer<ReminderCubit, ReminderState>(
          listener: (context, state) {
            // success - reminder activated
            if (state.actionStatus == ReminderStatus.success) {
              context.read<LibraryCubit>().refreshWord(
                  wordId: state.wordId!,
                  activeReminder: true,
                  reminder: state.reminder);

              showSnackBar(
                context,
                message: 'reminder_set_success'.tr(),
                icon: HeroIcons.checkCircle,
                iconColor: Colors.green,
              );
            }

            // removed
            else if (state.actionStatus == ReminderStatus.removed) {
              context.read<LibraryCubit>().refreshWord(
                  wordId: state.wordId!, activeReminder: false, reminder: null);

              showSnackBar(
                context,
                message: 'reminder_removed_success'.tr(),
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
          builder: (context, state) {
            final isLoading = state.actionStatus == ReminderStatus.loading;
            return CustomSwtich(
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
                } else {
                  context
                      .read<ReminderCubit>()
                      .unactiveReminder(widget.word.id);
                }
              },
              controller: ValueNotifier(isOptimisticReminder),
              icon: isOptimisticReminder ? HeroIcons.bell : HeroIcons.bellSlash,
              isLoading: isLoading,
            );
          },
        ),
      ],
    );
  }
}
