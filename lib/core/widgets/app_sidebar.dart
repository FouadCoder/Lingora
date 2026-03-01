import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:lingora/core/utils/app_constants.dart';

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
      leading: SizedBox(
        height: AppDimens.sectionSpacing,
      ),
      // selected

      selectedIconTheme: IconThemeData(
        color: colorScheme.onPrimary,
      ),
      selectedLabelTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
          fontSize: Theme.of(context).textTheme.titleMedium?.fontSize),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      // unselected
      unselectedIconTheme: IconThemeData(
        color: Theme.of(context).iconTheme.color,
      ),
      unselectedLabelTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleMedium?.color,
          fontSize: Theme.of(context).textTheme.titleMedium?.fontSize),

      destinations: [
        NavigationRailDestination(
          icon: const Icon(TablerIcons.sparkles),
          label: Text("translate".tr()),
        ),
        NavigationRailDestination(
          icon: const Icon(TablerIcons.home),
          label: Text("home".tr()),
        ),
        NavigationRailDestination(
          icon: const Icon(TablerIcons.book),
          label: Text("library".tr()),
        ),
        NavigationRailDestination(
          icon: const Icon(TablerIcons.chart_bar),
          label: Text("insights".tr()),
        ),
        NavigationRailDestination(
          icon: const Icon(TablerIcons.settings),
          label: Text("settings".tr()),
        ),
      ],
    );
  }
}
