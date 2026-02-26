import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/config/theme/app_colors.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/status/network_error_status.dart';
import 'package:lingora/features/words/domain/enums/collection_enum.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_state.dart';

class WordCollectionsWidget extends StatefulWidget {
  final String wordId;
  final CollectionType? collection;
  const WordCollectionsWidget(
      {super.key, required this.wordId, this.collection});

  @override
  State<WordCollectionsWidget> createState() => _WordCollectionsWidgetState();
}

class _WordCollectionsWidgetState extends State<WordCollectionsWidget> {
  CollectionType? collectionType;

  @override
  void initState() {
    super.initState();
    collectionType = widget.collection;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LibraryCubit, LibraryState>(
      listener: (context, state) {
        // Success
        if (state.collectionActionStatus == LibraryActionStatus.success) {
          showSnackBar(
            context,
            message: 'word_added_to_collection'.tr(),
            icon: HeroIcons.checkCircle,
            iconColor: AppColors.successGreen,
          );
        }
        // Error
        else if (state.collectionActionStatus == LibraryActionStatus.failure) {
          // Back the value again
          setState(() {
            collectionType = widget.collection;
          });
          showSnackBar(
            context,
            message: 'something_went_wrong'.tr(),
            icon: HeroIcons.exclamationTriangle,
            iconColor: Theme.of(context).colorScheme.error,
          );
        } else if (state.collectionActionStatus ==
            LibraryActionStatus.networkError) {
          // Back the value again
          setState(() {
            collectionType = widget.collection;
          });
          showErrorNetworkSnackBar(context);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: List.generate(CollectionType.values.length, (index) {
          bool isSelected = collectionType == CollectionType.values[index];
          final backgroundColor = (isSelected)
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface;

          return GestureDetector(
            onTap: () {
              setState(() {
                collectionType = CollectionType.values[index];
              });
              if (collectionType != widget.collection) {
                context.read<LibraryCubit>().updateWordCollection(
                    widget.wordId, CollectionType.values[index]);
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                  right: index < CollectionType.values.length - 1
                      ? AppDimens.buttonTagHorizontal
                      : 0),
              child: AppCard(
                  backgroundColor: backgroundColor,
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset(CollectionType.values[index].imagePath),
                  )),
            ),
          );
        }),
      ),
    );
  }
}
