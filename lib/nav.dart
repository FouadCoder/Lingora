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
  late List<Widget> pages;
  @override
  void initState() {
    super.initState();
    currentPage = widget.indexPage;

    pages = [
      TranslateScreen(),
      HomeScreen(),
      LibraryScreen(),
      InsightsScreen(),
      SettingScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppPlatform.isDesktop(context);

    return Scaffold(
      body: isDesktop
          ? Row(
              children: [
                AppSidebar(
                  selectedIndex: currentPage,
                  extended: isDesktop,
                  onDestinationSelected: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                ),
                Expanded(
                  child: pages[currentPage],
                ),
              ],
            )
          : pages[currentPage],
      bottomNavigationBar: isDesktop
          ? null
          : AnimatedBottomNavigationBar(
              icons: [
                TablerIcons.sparkles,
                TablerIcons.home,
                TablerIcons.book,
                TablerIcons.chart_bar,
                TablerIcons.settings,
              ],
              activeIndex: currentPage,
              onTap: (i) {
                setState(() {
                  currentPage = i;
                });
              },
              gapLocation: GapLocation.none,
              backgroundColor: Theme.of(context).colorScheme.surface,
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveColor: Theme.of(context).iconTheme.color,
              iconSize: 28,
            ),
    );
  }
}
