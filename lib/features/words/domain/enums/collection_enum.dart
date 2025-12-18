import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/config/theme/app_colors.dart';

enum CollectionType { learning, saved, masters }

extension CollectionTypeExt on CollectionType {
  String get displayName {
    switch (this) {
      case CollectionType.learning:
        return "learning".tr();
      case CollectionType.saved:
        return "saved".tr();
      case CollectionType.masters:
        return "mastered".tr();
    }
  }

  IconData get icon {
    switch (this) {
      case CollectionType.learning:
        return Icons.school;
      case CollectionType.saved:
        return Icons.bookmark;
      case CollectionType.masters:
        return Icons.emoji_events;
    }
  }

  String get imagePath {
    switch (this) {
      case CollectionType.learning:
        return "assets/icons/book.png";
      case CollectionType.saved:
        return "assets/icons/bookmark_12435234.png";
      case CollectionType.masters:
        return "assets/icons/crown_891024.png";
    }
  }

  TextStyle wordStyle(BuildContext context) {
    switch (this) {
      case CollectionType.learning:
        return Theme.of(context).textTheme.bodyMedium!;
      case CollectionType.saved:
        return Theme.of(context).textTheme.bodyMedium!;
      case CollectionType.masters:
        return Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: AppColors.gold, fontWeight: FontWeight.bold);
    }
  }
}
