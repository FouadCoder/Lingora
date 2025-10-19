import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/widgets/app_card.dart';

class CollectionsTranslate extends StatefulWidget {
  const CollectionsTranslate({super.key});

  @override
  State<CollectionsTranslate> createState() => _CollectionsTranslateState();
}

class _CollectionsTranslateState extends State<CollectionsTranslate> {
  int selectedIndex = 0;
  bool isActiveNotifications = false;
  @override
  Widget build(BuildContext context) {
    List collections = [
      {"name": "learning".tr(), "icon": Icons.school},
      {"name": "favorites".tr(), "icon": Icons.favorite},
      {"name": "saved".tr(), "icon": Icons.bookmark},
      {"name": "mastered".tr(), "icon": Icons.emoji_events},
      {
        "name": "notifications".tr(),
        "icon": Icons.notifications,
      },
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(collections.length, (index) {
        bool isNotification = index == collections.length - 1;
        bool isSelected = index == selectedIndex;
        bool isActiveNoti = isNotification && isActiveNotifications;
        final backgroundColor = (isSelected || isActiveNoti)
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.onSurface;

        return GestureDetector(
          onTap: () {
            if (isNotification) {
              setState(() {
                isActiveNotifications = !isActiveNotifications;
              });
            }
            if (!isNotification) {
              setState(() {
                selectedIndex = index;
              });
            }
          },
          child: Container(
            margin: EdgeInsets.only(
                right: index < collections.length - 1
                    ? AppDimens.buttonTagHorizontal
                    : 0),
            child: AppCard(
                backgroundColor: backgroundColor,
                child: Icon(
                  collections[index]["icon"],
                  size: 20,
                )),
          ),
        );
      }),
    );
  }
}
