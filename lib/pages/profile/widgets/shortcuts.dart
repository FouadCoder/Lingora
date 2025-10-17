import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/widgets/shortcut_widget.dart';

class ShortcutsProfile extends StatelessWidget {
  const ShortcutsProfile({super.key});

  @override
  Widget build(BuildContext context) {
    List shortcuts = [
      {"icon": Icons.history, "text": "history".tr()},
      {"icon": Icons.favorite, "text": "favorites".tr()},
      {"icon": Icons.notifications, "text": "notifications".tr()},
    ];
    return Row(
      children: List.generate(shortcuts.length, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index < shortcuts.length - 1 ? AppDimens.cardBetween : 0,
            ),
            child: ShortcutWidget(
                icon: shortcuts[index]["icon"], text: shortcuts[index]["text"]),
          ),
        );
      }),
    );
  }
}
