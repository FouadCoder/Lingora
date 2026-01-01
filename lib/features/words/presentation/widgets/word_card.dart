import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/widgets/icon_card.dart';
import 'package:lingora/features/words/presentation/widgets/heart_icon_widget.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/features/words/domain/enums/collection_enum.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';
import 'package:lingora/features/words/presentation/pages/library/word_details_screen.dart';

class WordCard extends StatefulWidget {
  final WordEntity word;
  final bool? smallCard;

  const WordCard({
    super.key,
    required this.word,
    this.smallCard = false,
  });

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.word.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    List chipsData = [
      {
        "text": widget.word.pos,
        "textColor": colorScheme.secondary,
      },
      {
        "text": widget.word.collection.collectionType.displayName,
        "textColor": colorScheme.secondary,
      },
    ];

    return AppCard(
      child: OpenContainer(
          closedColor: Theme.of(context).colorScheme.surface,
          openColor: Theme.of(context).colorScheme.surface,
          closedElevation: 0,
          openElevation: 0,
          transitionType: ContainerTransitionType.fadeThrough,
          transitionDuration: const Duration(milliseconds: 400),
          openBuilder: (context, openContainer) {
            return WordDetailsScreen(
              model: widget.word,
            );
          },
          closedBuilder: (context, openContainer) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.word.original,
                          style: theme.titleMedium,
                          maxLines: widget.smallCard! ? 1 : 2,
                        ),
                        SizedBox(width: AppDimens.subElementBetween),
                        Text(
                          widget.word.translated,
                          style: theme.titleMedium?.copyWith(
                            color: colorScheme.secondary,
                          ),
                          maxLines: widget.smallCard! ? 1 : 2,
                        ),
                      ],
                    ),
                    if (!widget.smallCard!)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //  Heart
                          HeartIconWidget(
                            word: widget.word,
                            onFavoriteChanged: (updatedWord) {
                              context
                                  .read<LibraryCubit>()
                                  .refreshWord(updatedWord);
                            },
                          ),

                          SizedBox(width: AppDimens.buttonTagHorizontal),
                          // Sound
                          IconCard(
                            icon: Icons.volume_up,
                            onTap: () {
                              context.read<LibraryCubit>().playAudio(
                                    widget.word.translated,
                                    widget.word.translateTo!.code,
                                  );
                            },
                          ),
                        ],
                      ),
                  ],
                ),

                SizedBox(height: AppDimens.sectionSpacing),
                // definition

                Text(
                  "meaning".tr(),
                  style: theme.bodyMedium?.copyWith(color: colorScheme.outline),
                ),
                SizedBox(height: AppDimens.elementBetween),
                Text(
                  widget.word.meaning,
                  style: theme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimens.sectionSpacing),

                // Example

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Text(
                    widget.word.examples[0],
                    style: theme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: AppDimens.sectionSpacing),
                if (!widget.smallCard!)
                  Center(
                    child: Wrap(
                      spacing: AppDimens.buttonTagHorizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 0,
                      children: List.generate(chipsData.length, (index) {
                        return Chip(
                          label: Text(
                            chipsData[index]["text"],
                            style: theme.bodySmall?.copyWith(
                                color: chipsData[index]["textColor"]),
                          ),
                          backgroundColor: colorScheme.onPrimary,
                          side: BorderSide.none,
                        );
                      }),
                    ),
                  )
              ],
            );
          }),
    );
  }
}
