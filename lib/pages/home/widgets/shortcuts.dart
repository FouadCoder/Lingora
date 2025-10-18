import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/widgets/shortcut_widget.dart';

class ShortcutsHome extends StatelessWidget {
  const ShortcutsHome({super.key});

  @override
  Widget build(BuildContext context) {
    List shortcuts = [
      {
        "icon": Icons.history,
        "text": "history".tr(),
        "route": "/nav/home/history"
      },
      {"icon": Icons.favorite, "text": "favorites".tr(), "route": ""},
      {"icon": Icons.notifications, "text": "notifications".tr(), "route": ""},
    ];
    return Row(
      children: List.generate(shortcuts.length, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index < shortcuts.length - 1 ? AppDimens.cardBetween : 0,
            ),
            child: ShortcutWidget(
              icon: shortcuts[index]["icon"],
              text: shortcuts[index]["text"],
              onTap: () {
                context.push(shortcuts[index]["route"]);
              },
            ),
          ),
        );
      }),
    );
  }
}
