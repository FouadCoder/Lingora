import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/pages/home.dart';
import 'package:lingora/pages/library.dart';
import 'package:lingora/pages/practice.dart';
import 'package:lingora/pages/profile.dart';
import 'package:lingora/pages/translate.dart';
import 'package:lingora/widgets/app_sidebar.dart';
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
  final controllerSideBar =
      SidebarXController(selectedIndex: 0, extended: true); // For side bar

  @override
  void initState() {
    super.initState();
    currentPage = widget.indexPage;

    pages = [
      HomeScreen(),
      TranslateScreen(),
      LibraryScreen(),
      PracticeScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: AppPlatform.isDesktop(context)
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
      ),
      bottomNavigationBar: AppPlatform.isDesktop(context)
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    icon: const Icon(Icons.flag_rounded),
                    title: Text("practice".tr()),
                    selectedColor: Theme.of(context).colorScheme.secondary,
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.person_rounded),
                    title: Text("profile".tr()),
                    selectedColor: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
    );
  }
}
