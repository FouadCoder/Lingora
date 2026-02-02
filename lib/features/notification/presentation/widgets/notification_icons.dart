import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class NotificationIconConfig {
  final HeroIcons icon;
  final String keyword;
  final Color color;

  const NotificationIconConfig({
    required this.icon,
    required this.keyword,
    required this.color,
  });

  static const List<NotificationIconConfig> list = [
    NotificationIconConfig(
      icon: HeroIcons.bell,
      keyword: "bell",
      color: Color(0xFFFF6F00), // Brand - standard notifications
    ),
    NotificationIconConfig(
      icon: HeroIcons.wrenchScrewdriver,
      keyword: "updates",
      color: Color(0xFF607D8B), // Blue Grey - updates/maintenance
    ),
    NotificationIconConfig(
      icon: HeroIcons.gift,
      keyword: "gift",
      color: Color(0xFFFF9800), // Orange - gifts/rewards
    ),
    NotificationIconConfig(
      icon: HeroIcons.heart,
      keyword: "heart",
      color: Color(0xFFE91E63), // Pink - likes/favorites
    ),
    NotificationIconConfig(
      icon: HeroIcons.sparkles,
      keyword: "sparkles",
      color: Color(0xFFFFEB3B), // Yellow - magic/special
    ),
    NotificationIconConfig(
      icon: HeroIcons.bookOpen,
      keyword: "book",
      color: Color(0xFFFF6F00), // Brand - ratings/achievements
    ),
    NotificationIconConfig(
      icon: HeroIcons.fire,
      keyword: "fire",
      color: Color(0xFFFF5722), // Orange-Red - trending/hot
    ),
    NotificationIconConfig(
      icon: HeroIcons.bolt,
      keyword: "bolt",
      color: Color(0xFFFFEB3B), // Yellow - energy/power
    ),
    NotificationIconConfig(
      icon: HeroIcons.flag,
      keyword: "flag",
      color: Color(0xFF3F51B5), // Indigo - important/flagged
    ),
    NotificationIconConfig(
      icon: HeroIcons.checkCircle,
      keyword: "success",
      color: Color(0xFF4CAF50), // Green - success/completion
    ),
  ];

  static NotificationIconConfig getByKeyword(String keyword) {
    try {
      return list.firstWhere((icon) => icon.keyword == keyword);
    } catch (e) {
      // Fallback to bell icon if keyword not found
      return list.firstWhere((icon) => icon.keyword == 'bell');
    }
  }
}
