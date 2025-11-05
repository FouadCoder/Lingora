import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lingora/features/translate/domain/entities/translate_entity.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/core/extensions/datetime_style.dart';
import 'package:lingora/core/widgets/app_card.dart';

class WordCard extends StatefulWidget {
  final TranslateEntity word;
  final bool? smallCard;

  const WordCard({super.key, required this.word, this.smallCard = false});

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  bool isFavorite = false;
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
        "text": "Test category ",
        "textColor": colorScheme.secondary,
      },
      {
        "text": widget.word.createdAt.toReadableDate(),
        "textColor": theme.bodySmall?.color,
      },
    ];

    return AppCard(
      child: InkWell(
        onTap: () {
          context.push('/nav/library/word_details', extra: widget.word);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: Color(0xFFFF914D),
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
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() => isFavorite = !isFavorite);
                          if (isFavorite) {
                            context
                                .read<FavoritesCubit>()
                                .addToFavorites(widget.word.id!);
                          } else {
                            context
                                .read<FavoritesCubit>()
                                .removeFromFavorites(widget.word.id!);
                          }
                        },
                        child: Icon(
                          Icons.favorite,
                          color: isFavorite ? Colors.red : colorScheme.outline,
                        ),
                      ),
                      SizedBox(width: AppDimens.sectionSpacing),
                      // 🔊 Sound
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          // play sound
                        },
                        child: Icon(
                          Icons.volume_up,
                          color: colorScheme.outline,
                        ),
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
              Wrap(
                spacing: AppDimens.buttonTagHorizontal,
                runSpacing: 0,
                children: List.generate(chipsData.length, (index) {
                  return Chip(
                    label: Text(
                      chipsData[index]["text"],
                      style: theme.bodySmall
                          ?.copyWith(color: chipsData[index]["textColor"]),
                    ),
                    backgroundColor: colorScheme.onPrimary,
                    side: BorderSide.none,
                  );
                }),
              )
          ],
        ),
      ),
    );
  }
}
