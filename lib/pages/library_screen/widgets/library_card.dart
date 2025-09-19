import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/extensions/datetime_style.dart';
import 'package:lingora/models/translate.dart';
import 'package:lingora/widgets/app_card.dart';

class WordCard extends StatelessWidget {
  final Translate word;

  const WordCard({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    List chipsData = [
      {
        "text": word.pos,
        "textColor": colorScheme.secondary,
      },
      {
        "text": "Test category ",
        "textColor": colorScheme.secondary,
      },
      {
        "text": word.createdAt.toReadableDate(),
        "textColor": theme.bodySmall?.color,
      },
    ];

    return AppCard(
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
                    word.original,
                    style: theme.titleMedium,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    word.translated,
                    style:
                        theme.titleMedium?.copyWith(color: Color(0xFFFF914D)),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.volume_up),
                color: colorScheme.outline,
                style: IconButton.styleFrom(
                  hoverColor: colorScheme.onSurface,
                  focusColor: colorScheme.onSurface,
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          // definition
          Text(
            "meaning".tr(),
            style: theme.bodyMedium?.copyWith(color: colorScheme.outline),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            word.meaning,
            style: theme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Example
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(
              word.examples[0],
              style: theme.bodySmall,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 4,
            runSpacing: 4,
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
    );
  }
}
