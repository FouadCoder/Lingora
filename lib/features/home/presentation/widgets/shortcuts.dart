import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/widgets/shortcut_widget.dart';

class ShortcutsHome extends StatelessWidget {
  const ShortcutsHome({super.key});

  @override
  Widget build(BuildContext context) {
    List shortcuts = [
      {"icon": HeroIcons.clock, "text": "history".tr(), "route": "/history"},
      {
        "icon": HeroIcons.heart,
        "text": "favorites".tr(),
        "route": "/favorites"
      },
      {
        "icon": HeroIcons.bell,
        "text": "notifications".tr(),
        "route": "/notifications"
      },
    ];
    return Row(
      children: List.generate(shortcuts.length, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
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
