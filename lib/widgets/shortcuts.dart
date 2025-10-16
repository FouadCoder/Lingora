import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/pages/profile/widgets/shortcut_widget.dart';

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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(shortcuts.length, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: AppDimens.cardBetween),
            child: ShortcutWidget(
                icon: shortcuts[index]["icon"], text: shortcuts[index]["text"]),
          ),
        );
      }),
    );
  }
}
