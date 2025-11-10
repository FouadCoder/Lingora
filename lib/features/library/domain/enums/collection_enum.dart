import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum CollectionType { learning, favorites, saved, mastered, notifications }

extension CollectionTypeExt on CollectionType {
  String get name {
    switch (this) {
      case CollectionType.learning:
        return "learning".tr();
      case CollectionType.favorites:
        return "favorites".tr();
      case CollectionType.saved:
        return "saved".tr();
      case CollectionType.mastered:
        return "mastered".tr();
      case CollectionType.notifications:
        return "notifications".tr();
    }
  }

  IconData get icon {
    switch (this) {
      case CollectionType.learning:
        return Icons.school;
      case CollectionType.favorites:
        return Icons.favorite;
      case CollectionType.saved:
        return Icons.bookmark;
      case CollectionType.mastered:
        return Icons.emoji_events;
      case CollectionType.notifications:
        return Icons.notifications;
    }
  }

  String get id => name.toLowerCase();
}
