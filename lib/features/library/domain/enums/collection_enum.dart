import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum CollectionType { learning, saved, mastered }

extension CollectionTypeExt on CollectionType {
  String get name {
    switch (this) {
      case CollectionType.learning:
        return "learning".tr();
      case CollectionType.saved:
        return "saved".tr();
      case CollectionType.mastered:
        return "mastered".tr();
    }
  }

  IconData get icon {
    switch (this) {
      case CollectionType.learning:
        return Icons.school;
      case CollectionType.saved:
        return Icons.bookmark;
      case CollectionType.mastered:
        return Icons.emoji_events;
    }
  }

  String get imagePath {
    switch (this) {
      case CollectionType.learning:
        return "assets/icons/book.png";
      case CollectionType.saved:
        return "assets/icons/bookmark_10.png";
      case CollectionType.mastered:
        return "assets/icons/trophy_10.png";
    }
  }

  String get sourceName {
    switch (this) {
      case CollectionType.learning:
        return "Learning";
      case CollectionType.saved:
        return "Saved";
      case CollectionType.mastered:
        return "Mastered";
    }
  }
}
