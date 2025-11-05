import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lingora/core/widgets/header.dart';
import 'package:lingora/core/widgets/textfield.dart';

class LibraryNotes extends StatefulWidget {
  const LibraryNotes({super.key});

  @override
  State<LibraryNotes> createState() => _LibraryNotesState();
}

class _LibraryNotesState extends State<LibraryNotes> {
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(icon: MaterialCommunityIcons.pen, title: 'notes'.tr()),
        CustomTextfield(
            controller: noteController, label: '', hint: 'notes_hint'.tr()),
      ],
    );
  }
}
