import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/features/library/domain/enums/collection_enum.dart';
import 'package:lingora/features/library/presentation/cubit/library_cubit.dart';
import 'package:lingora/features/library/presentation/cubit/library_state.dart';

class WordCollectionsWidget extends StatefulWidget {
  final String? wordId;
  final CollectionType? collection;
  const WordCollectionsWidget(
      {super.key, required this.wordId, this.collection});

  @override
  State<WordCollectionsWidget> createState() => _WordCollectionsWidgetState();
}

class _WordCollectionsWidgetState extends State<WordCollectionsWidget> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.collection?.index;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LibraryCubit, LibraryState>(
      listener: (context, state) {
        // Success
        if (state.actionStatus == LibraryActionStatus.success) {
          showSnackBar(
            context,
            message: 'word_added_to_collection'.tr(),
            icon: Icons.verified_rounded,
            iconColor: Theme.of(context).colorScheme.secondary,
          );
        }
        // Error
        else if (state.actionStatus == LibraryActionStatus.failure) {
          showSnackBar(
            context,
            message: 'something_went_wrong'.tr(),
            icon: Icons.error_outline,
            iconColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: List.generate(CollectionType.values.length, (index) {
          bool isSelected = index == selectedIndex;
          final backgroundColor = (isSelected)
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.onSurface;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              context.read<LibraryCubit>().updateWordCollection(
                  widget.wordId!, CollectionType.values[index]);
            },
            child: Container(
              margin: EdgeInsets.only(
                  right: index < CollectionType.values.length - 1
                      ? AppDimens.buttonTagHorizontal
                      : 0),
              child: AppCard(
                  backgroundColor: backgroundColor,
                  child: Icon(
                    CollectionType.values[index].icon,
                    size: 20,
                  )),
            ),
          );
        }),
      ),
    );
  }
}
