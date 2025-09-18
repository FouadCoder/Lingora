import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/extensions/datetime_style.dart';
import 'package:lingora/models/translate.dart';

class WordCard extends StatelessWidget {
  final Translate word;

  const WordCard({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppDimens.paddingM),
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2), // Increased opacity
              blurRadius: 5,
              spreadRadius: 0.1,
              offset: Offset(0, 4),
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  word.original,
                  style: theme.titleMedium,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  word.translated,
                  style: theme.titleMedium?.copyWith(color: Color(0xFFFF914D)),
                ),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              word.pos,
              style: theme.bodySmall
                  ?.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
            ),
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
          Row(
            children: [
              Chip(
                label: Text(
                  "Test category",
                  style:
                      theme.bodySmall?.copyWith(color: colorScheme.secondary),
                ),
                backgroundColor: colorScheme.onPrimary,
                side: BorderSide.none,
              ),
              const SizedBox(width: 10),
              Text(
                word.createdAt.toReadableDate(),
                style: theme.bodySmall?.copyWith(color: colorScheme.outline),
              ),
            ],
          )
        ],
      ),
    );
  }
}
