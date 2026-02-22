import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/status/network_error_status.dart';
import 'package:lingora/features/notification/presentation/cubit/reminders/reminder_cubit.dart';
import 'package:lingora/features/notification/presentation/cubit/reminders/reminder_state.dart';
import 'package:lingora/core/widgets/custom_swtich.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';

class ReminderSwitchWidget extends StatefulWidget {
  final String wordId;

  const ReminderSwitchWidget({
    super.key,
    required this.wordId,
  });

  @override
  State<ReminderSwitchWidget> createState() => _ReminderSwitchWidgetState();
}

class _ReminderSwitchWidgetState extends State<ReminderSwitchWidget> {
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final libraryState = context.watch<LibraryCubit>().state;

    final word = libraryState.libraryWords.firstWhere(
      (w) => w.id == widget.wordId,
    );

    return BlocConsumer<ReminderCubit, ReminderState>(
      listener: (context, state) {
        if (state.wordId != word.id) return;

        if (state.actionStatus == ReminderStatus.success) {
          context.read<LibraryCubit>().refreshWord(
                wordId: state.wordId!,
                activeReminder: true,
                reminder: state.reminder,
              );

          audioPlayer.play(AssetSource('sound/reminder.mp3'));

          showSnackBar(
            context,
            message: 'reminder_set_success'.tr(),
            icon: HeroIcons.checkCircle,
            iconColor: Colors.green,
          );
        } else if (state.actionStatus == ReminderStatus.removed) {
          context.read<LibraryCubit>().refreshWord(
                wordId: state.wordId!,
                activeReminder: false,
                reminder: null,
              );

          showSnackBar(
            context,
            message: 'reminder_removed_success'.tr(),
            icon: HeroIcons.checkCircle,
            iconColor: Colors.green,
          );
        } else if (state.actionStatus == ReminderStatus.error) {
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
      builder: (context, state) {
        final isLoading = state.actionStatus == ReminderStatus.loading;

        return CustomSwtich(
          title: 'reminders_title'.tr(),
          description: word.activeReminder
              ? 'reminders_active'.tr()
              : 'reminders_inactive'.tr(),
          onChanged: (value) {
            if (value) {
              context.read<ReminderCubit>().activeReminder(word);
            } else {
              context
                  .read<ReminderCubit>()
                  .unactiveReminder(word.reminder!.id, word.id);
            }
          },
          controller: ValueNotifier(word.activeReminder),
          icon: word.activeReminder ? HeroIcons.bell : HeroIcons.bellSlash,
          isLoading: isLoading,
        );
      },
    );
  }
}
