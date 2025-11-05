import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/features/translate/presentation/pages/translate_screen.dart';
import 'package:lingora/pages/home/home.dart';
import 'package:lingora/features/library/presentation/pages/library_screen.dart';
import 'package:lingora/pages/insights/insights.dart';
import 'package:lingora/pages/setting/setting.dart';
import 'package:lingora/core/widgets/app_sidebar.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class Nav extends StatefulWidget {
  final int indexPage;
  const Nav({
    super.key,
    this.indexPage = 0,
  });

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  late int currentPage;
  late List pages;
  late SidebarXController controllerSideBar;

  @override
  void initState() {
    super.initState();
    currentPage = widget.indexPage;
    controllerSideBar =
        SidebarXController(selectedIndex: widget.indexPage, extended: true);

    pages = [
      HomeScreen(),
      TranslateScreen(),
      LibraryScreen(),
      InsightsScreen(),
      SettingScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPlatform.isDesktop(context)
          ? Row(
              children: [
                // Side bar
                AppSidebar(controller: controllerSideBar),

                // Content
                Expanded(
                  child: pages[controllerSideBar.selectedIndex],
                ),
              ],
            )
          : pages[currentPage],
      bottomNavigationBar: AppPlatform.isDesktop(context)
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: SalomonBottomBar(
                currentIndex: currentPage,
                onTap: (i) => setState(() => currentPage = i),
                items: [
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.home_rounded),
                    title: Text("home".tr()),
                    selectedColor: Theme.of(context).colorScheme.secondary,
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.translate_rounded),
                    title: Text("translate".tr()),
                    selectedColor: Theme.of(context).colorScheme.secondary,
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.book_rounded),
                    title: Text("library".tr()),
                    selectedColor: Theme.of(context).colorScheme.secondary,
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.insert_chart_outlined),
                    title: Text("insights".tr()),
                    selectedColor: Theme.of(context).colorScheme.secondary,
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.settings),
                    title: Text("settings".tr()),
                    selectedColor: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
    );
  }
}
