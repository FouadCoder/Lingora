import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/features/home/presentation/pages/home_screen.dart';
import 'package:lingora/features/translate/presentation/pages/translate_screen.dart';
import 'package:lingora/features/words/presentation/pages/library/library_screen.dart';
import 'package:lingora/features/analytics/presentation/pages/insights_screen.dart';
import 'package:lingora/features/settings/presentation/pages/setting.dart';
import 'package:lingora/core/widgets/app_sidebar.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class Nav extends StatefulWidget {
  final int indexPage;
  final bool isFullScreen;
  const Nav({
    super.key,
    this.indexPage = 10, // Fake number
    this.isFullScreen = false,
  });

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  late int currentPage;
  late List pages;
  bool? isCenterScreen;
  late SidebarXController controllerSideBar;

  @override
  void initState() {
    super.initState();
    currentPage = widget.indexPage;
    isCenterScreen = widget.isFullScreen;
    controllerSideBar =
        SidebarXController(selectedIndex: widget.indexPage, extended: false);

    controllerSideBar.addListener(() {
      setState(() {
        currentPage = controllerSideBar.selectedIndex;
      });
    });

    pages = [
      HomeScreen(),
      LibraryScreen(),
      InsightsScreen(),
      SettingScreen(),
    ];
  }

  @override
  void dispose() {
    controllerSideBar.dispose();
    super.dispose();
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
          : isCenterScreen!
              ? TranslateScreen()
              : pages[currentPage],
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          isCenterScreen = true;
          currentPage = 10; // Fake number
        }),
        elevation: 6,
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.translate_rounded,
          color: Theme.of(context).iconTheme.color,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppPlatform.isDesktop(context)
          ? null
          : AnimatedBottomNavigationBar(
              icons: [
                TablerIcons.home,
                TablerIcons.book,
                TablerIcons.chart_bar,
                TablerIcons.settings,
              ],
              activeIndex: currentPage,
              onTap: (i) => setState(() {
                isCenterScreen = false;
                currentPage = i;
              }),
              notchMargin: 18,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.defaultEdge,
              backgroundColor: Theme.of(context).colorScheme.surface,
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveColor: Theme.of(context).iconTheme.color,
              iconSize: 28,
            ),
    );
  }
}
