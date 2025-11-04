import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/flushbar.dart';

class CollectionsTranslate extends StatefulWidget {
  final bool hideNotifications;
  final String wordId;
  const CollectionsTranslate(
      {super.key, this.hideNotifications = false, required this.wordId});

  @override
  State<CollectionsTranslate> createState() => _CollectionsTranslateState();
}

class _CollectionsTranslateState extends State<CollectionsTranslate> {
  int selectedIndex = 0;
  bool isActiveNotifications = false;
  @override
  Widget build(BuildContext context) {
    List collections = [
      {"name": "learning".tr(), "icon": Icons.school, "id": "Learning"},
      {"name": "favorites".tr(), "icon": Icons.favorite, "id": "Favorites"},
      {"name": "saved".tr(), "icon": Icons.bookmark, "id": "Saved"},
      {"name": "mastered".tr(), "icon": Icons.emoji_events, "id": "Masters"},
      {
        "name": "notifications".tr(),
        "icon": Icons.notifications,
      },
    ];
    return BlocListener<CategoryCubit, CategoryState>(
      listener: (context, state) {
        // Success
        if (state.status == CategoryStatus.success) {
          showSnackBar(
            context,
            message: 'word_added_to_collection'.tr(),
            icon: Icons.verified_rounded,
            iconColor: Theme.of(context).colorScheme.secondary,
          );
        }
        // Error
        else if (state.status == CategoryStatus.failure) {
          showSnackBar(
            context,
            message: 'something_went_wrong'.tr(),
            icon: Icons.error_outline,
            iconColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: List.generate(
            widget.hideNotifications ? 4 : collections.length, (index) {
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
                context
                    .read<CategoryCubit>()
                    .addWordToCategory(widget.wordId, collections[index]["id"]);
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
      ),
    );
  }
}
