import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum CollectionType { learning, favorites, saved, mastered, notifications }

extension CollectionTypeExt on CollectionType {
  String get name {
    switch (this) {
      case CollectionType.favorites:
        return "favorites".tr();
      case CollectionType.learning:
        return "learning".tr();
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
      case CollectionType.favorites:
        return Icons.favorite;
      case CollectionType.learning:
        return Icons.school;
      case CollectionType.saved:
        return Icons.bookmark;
      case CollectionType.mastered:
        return Icons.emoji_events;
      case CollectionType.notifications:
        return Icons.notifications;
    }
  }

  String get imagePath {
    switch (this) {
      case CollectionType.learning:
        return "assets/icons/layer_10.png";
      case CollectionType.favorites:
        return "assets/icons/heart_72.png";
      case CollectionType.saved:
        return "assets/icons/bookmark_10.png";
      case CollectionType.mastered:
        return "assets/icons/trophy_10.png";
      case CollectionType.notifications:
        return "assets/icons/layer_10.png"; // Doesn't have image
    }
  }

  String get sourceName {
    switch (this) {
      case CollectionType.learning:
        return "Learning";
      case CollectionType.favorites:
        return "Favorites";
      case CollectionType.saved:
        return "Saved";
      case CollectionType.mastered:
        return "Masters";
      case CollectionType.notifications:
        return "Notifications";
    }
  }
}
