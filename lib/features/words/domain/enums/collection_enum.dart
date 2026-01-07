import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/config/theme/app_colors.dart';

enum CollectionType { learning, saved, masters }

extension CollectionTypeExt on CollectionType {
  static CollectionType fromString(String value) {
    switch (value) {
      case 'learning':
        return CollectionType.learning;
      case 'saved':
        return CollectionType.saved;
      case 'masters':
        return CollectionType.masters;
      default:
        return CollectionType.learning;
    }
  }

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

  HeroIcons get icon {
    switch (this) {
      case CollectionType.learning:
        return HeroIcons.academicCap;
      case CollectionType.saved:
        return HeroIcons.bookmark;
      case CollectionType.masters:
        return HeroIcons.sparkles;
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
