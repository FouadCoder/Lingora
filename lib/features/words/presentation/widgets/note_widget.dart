import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/custom_button.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/header.dart';
import 'package:lingora/core/widgets/textfield.dart';
import 'package:lingora/features/words/domain/entities/note_entity.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/presentation/cubit/notes/notes_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/notes/notes_state.dart';

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
            icon: Icons.verified_rounded,
            iconColor: Theme.of(context).colorScheme.secondary,
          );
          // Update initialNote
          setState(() {
            initialNote = noteController.text;
          });
        }
        // Error
        else if (state.status == NotesStatus.failure) {
          showSnackBar(
            context,
            message: 'something_went_wrong'.tr(),
            icon: Icons.error_outline,
            iconColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      child: Column(
        children: [
          Header(icon: MaterialCommunityIcons.pen, title: 'notes'.tr()),
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
                    color: Theme.of(context).colorScheme.secondary,
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
