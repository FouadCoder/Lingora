import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class AppSidebar extends StatelessWidget {
  final SidebarXController controller;

  const AppSidebar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final divider =
        Divider(color: Theme.of(context).colorScheme.surface, height: 1);

    return SidebarX(
      controller: controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        hoverColor: Theme.of(context).colorScheme.onPrimary,
        hoverTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary),
        hoverIconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.primary),
        selectedItemTextPadding: const EdgeInsets.only(left: 50),
        itemTextPadding:
            const EdgeInsets.only(left: 50), // Increased spacing even more
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.transparent,
            width: 1,
          ),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary,
        ),
        textStyle: Theme.of(context).textTheme.bodyMedium,
        selectedTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 250, // Increased width for better spacing
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
      footerDivider: divider,
      footerItems: [],
      items: [
        SidebarXItem(
          icon: Icons.home_rounded,
          label: "home".tr(),
        ),
        SidebarXItem(
          icon: Icons.translate_rounded,
          label: "translate".tr(),
        ),
        SidebarXItem(
          icon: Icons.book_rounded,
          label: "library".tr(),
        ),
        SidebarXItem(
          icon: Icons.insert_chart_outlined,
          label: "Insights".tr(),
        ),
        SidebarXItem(
          icon: Icons.settings,
          label: "settings".tr(),
        ),
      ],
    );
  }
}
