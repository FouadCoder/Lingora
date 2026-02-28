import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lottie/lottie.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.extended = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationRail(
      extended: extended,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: colorScheme.surface,
      useIndicator: true,
      indicatorColor: colorScheme.primary,
      leading: leadingWidget(context),

      // selected
      selectedIconTheme: IconThemeData(
        color: colorScheme.onPrimary,
      ),
      selectedLabelTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
      ),

      // unselected
      unselectedIconTheme: IconThemeData(
        color: Theme.of(context).iconTheme.color,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: Theme.of(context).textTheme.titleMedium?.color,
      ),

      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.home_rounded),
          label: Text("home".tr()),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.translate_rounded),
          label: Text("translate".tr()),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.book_rounded),
          label: Text("library".tr()),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.insert_chart_outlined),
          label: Text("Insights".tr()),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.settings),
          label: Text("settings".tr()),
        ),
      ],
    );
  }
}

Widget leadingWidget(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(
        vertical: AppDimens.sectionBetween,
        horizontal: AppDimens.buttonTagHorizontal),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // App Icon
        Lottie.asset(
          "assets/animation/world_language.json",
          height: 32,
          width: 32,
        ),
        SizedBox(
          width: AppDimens.buttonTagHorizontal,
        ),
        // App name
        Text(
          "Lingora",
          style: Theme.of(context).textTheme.displayLarge,
        )
      ],
    ),
  );
}
