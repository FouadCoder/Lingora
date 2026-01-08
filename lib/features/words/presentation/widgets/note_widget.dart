import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/config/theme/app_colors.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/custom_button.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/header.dart';
import 'package:lingora/core/widgets/status/network_error_status.dart';
import 'package:lingora/core/widgets/textfield.dart';
import 'package:lingora/features/words/domain/entities/note_entity.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/presentation/cubit/notes/notes_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/notes/notes_state.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';

class LibraryNotes extends StatefulWidget {
  final NoteEntity noteEntity;
  final WordEntity? word;
  const LibraryNotes({super.key, required this.noteEntity, required this.word});

  @override
  State<LibraryNotes> createState() => _LibraryNotesState();
}

class _LibraryNotesState extends State<LibraryNotes> {
  final TextEditingController noteController = TextEditingController();
  String initialNote = '';

  @override
  void initState() {
    super.initState();
    initialNote = widget.noteEntity.content;
    noteController.text = widget.noteEntity.content;
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typeed = noteController.text != initialNote;
    return BlocListener<NotesCubit, NotesState>(
      listener: (context, state) {
        // Success
        if (state.status == NotesStatus.success) {
          showSnackBar(
            context,
            message: 'note_saved'.tr(),
            icon: HeroIcons.checkCircle,
            iconColor: AppColors.successGreen,
          );
          // Update initialNote
          setState(() {
            initialNote = noteController.text;
          });
          // Refresh word
          context.read<LibraryCubit>().refreshWord(state.word!);
        }
        // Error
        else if (state.status == NotesStatus.failure) {
          showSnackBar(
            context,
            message: 'something_went_wrong'.tr(),
            icon: HeroIcons.exclamationTriangle,
            iconColor: Theme.of(context).colorScheme.error,
          );
        }
        // Network Error
        else if (state.status == NotesStatus.networkError) {
          showErrorNetworkSnackBar(context);
        }
      },
      child: Column(
        children: [
          Header(icon: HeroIcons.pencil, title: 'notes'.tr()),
          CustomTextfield(
              controller: noteController,
              label: '',
              keyboardType: TextInputType.multiline,
              hint: "notes_hint".tr(),
              maxLength: 1000,
              onChange: (value) {
                setState(() {});
              }),
          if (typeed)
            SizedBox(
              height: AppDimens.sectionSpacing,
            ),
          if (typeed)
            BlocBuilder<NotesCubit, NotesState>(
              builder: (context, state) {
                bool isLoading = state.status == NotesStatus.loading;
                return Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: CustomButton(
                    text: 'save'.tr(),
                    isLoading: isLoading,
                    color: Theme.of(context).colorScheme.primary,
                    function: () {
                      context
                          .read<NotesCubit>()
                          .updateNote(noteController.text.trim(), widget.word!);
                    },
                    textColor: Colors.white,
                    width: AppButtonSizes.smallWidth(context),
                  ),
                );
              },
            )
        ],
      ),
    );
  }
}
