import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/constants/module_constant.dart';
import 'package:quiz_app/notifiers/auth_notifier.dart';
import 'package:quiz_app/pages/admin/admin_page.dart';
import 'package:quiz_app/pages/category/category_list_page.dart';
import 'package:quiz_app/pages/profile/profile_page.dart';
import 'package:quiz_app/pages/quiz/quiz_list_page.dart';

class RootPage extends ConsumerStatefulWidget {
  const RootPage({super.key});

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  int _currentIndex = 0;

  final List<BottomMenuModel> menus = [
    BottomMenuModel(
      page: QuizListPage(),
      title: 'Beranda',
      icon: Icons.home,
      moduleNames: [ModuleConstant.searchQuiz],
      index: 0
    ),
    BottomMenuModel(
      page: CategoryListPage(),
      title: 'Kategori',
      icon: Icons.category,
      moduleNames: [ModuleConstant.searchCategory, ModuleConstant.detailCategory],
      index: 1
    ),
    BottomMenuModel(
      page: AdminPage(),
      title: 'Admin',
      icon: Icons.admin_panel_settings,
      moduleNames: [ModuleConstant.searchUser, ModuleConstant.searchRole],
      index: 2
    ),
    BottomMenuModel(
      page: ProfilePage(),
      title: 'Profile',
      moduleNames: [],
      index: 3
    )
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final modules = state.token?.user?.role?.roleModules;
    final colors = Theme.of(context).colorScheme;

    final shownMenus = menus
      .where((menu) => modules != null && menu.moduleNames.every((moduleName) => modules.any((module) => module.roleModuleName == moduleName)))
      .toList();

    return Scaffold(
      body: shownMenus[_currentIndex].page,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: colors.primary,
        selectedItemColor: colors.onPrimary,
        unselectedItemColor: Colors.white,
        items: shownMenus.map((menu) {
            if (menu.icon != null) {
              return BottomNavigationBarItem(
                icon: Icon(menu.icon),
                label: menu.title
              );            
            }

            return BottomNavigationBarItem(
              icon: ProfileImageComponent(
                profileImage: state.token?.user?.profileImage,
                radius: 11,
              ),
              label: menu.title
            );
          }).toList()
      ),
    );
  }
}

class BottomMenuModel {
  Widget page;
  String title;
  List<String> moduleNames;
  int index;
  IconData? icon;

  BottomMenuModel({
    required this.page,
    required this.title,
    required this.moduleNames,
    required this.index,
    this.icon,
  });
}