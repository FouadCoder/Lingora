import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/extensions/datetime_style.dart';
import 'package:lingora/core/widgets/icon_card.dart';
import 'package:lingora/features/words/presentation/widgets/heart_icon_widget.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/features/words/domain/enums/collection_enum.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';
import 'package:lingora/features/words/presentation/pages/library/word_details_screen.dart';
import 'package:lingora/helper/direction_helper.dart';

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
      widget.word.pos,
      widget.word.collection.collectionType.displayName,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Original
                        Text(
                          widget.word.original,
                          style: theme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                          maxLines: widget.smallCard! ? 1 : 2,
                          textAlign:
                              isRightSide(widget.word.translateFrom!.code)
                                  ? TextAlign.right
                                  : TextAlign.left,
                        ),
                        SizedBox(width: AppDimens.subElementBetween),
                        // Translated
                        Text(
                          widget.word.translated,
                          style: theme.titleMedium,
                          textAlign: isRightSide(widget.word.translateTo!.code)
                              ? TextAlign.right
                              : TextAlign.left,
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
                            icon: HeroIcons.speakerWave,
                            onTap: () {
                              context.read<LibraryCubit>().playAudio(
                                    widget.word.original,
                                    widget.word.translateFrom!.code,
                                  );
                            },
                          ),
                        ],
                      ),
                  ],
                ),

                SizedBox(height: AppDimens.sectionSpacing),
                // Example
                Text(
                  '“ ${widget.word.examples[0]} ”',
                  style: theme.bodyMedium,
                  maxLines: 2,
                  textAlign: isRightSide(widget.word.translateTo!.code)
                      ? TextAlign.right
                      : TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: AppDimens.sectionSpacing),
                if (!widget.smallCard!)
                  Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.2),
                    height: 0.1,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: AppDimens.buttonTagHorizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 0,
                      children: List.generate(chipsData.length, (index) {
                        return Chip(
                          label: Text(
                            chipsData[index],
                            style: theme.bodySmall
                                ?.copyWith(color: colorScheme.primary),
                          ),
                          backgroundColor: colorScheme.onSurface,
                          side: BorderSide(
                              width: 0.5,
                              color:
                                  colorScheme.outline.withValues(alpha: 0.1)),
                        );
                      }),
                    ),

                    // Translated at
                    Text(
                      " ${widget.word.createdAt.toDayAndShortMonth()}",
                      style: theme.bodySmall,
                    ),
                  ],
                )
              ],
            );
          }),
    );
  }
}
