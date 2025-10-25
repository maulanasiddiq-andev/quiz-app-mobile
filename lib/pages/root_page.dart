import 'package:flutter/material.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/pages/admin/admin_page.dart';
import 'package:quiz_app/pages/category/category_list_page.dart';
import 'package:quiz_app/pages/profile/profile_page.dart';
import 'package:quiz_app/pages/quiz/quiz_list_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  final List<BottomMenuModel> menus = [
    BottomMenuModel(
      page: QuizListPage(),
      title: 'Beranda',
      icon: Icons.home,
    ),
    BottomMenuModel(
      page: CategoryListPage(),
      title: 'Kategori',
      icon: Icons.category,
    ),
    BottomMenuModel(
      page: AdminPage(),
      title: 'Admin',
      icon: Icons.admin_panel_settings,
    ),
    BottomMenuModel(
      page: ProfilePage(),
      title: 'Profile',
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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: menus[_currentIndex].page,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: colors.primary,
        selectedItemColor: colors.onPrimary,
        unselectedItemColor: Colors.white,
        items: menus.map((menu) {
          if (menu.icon != null) {
            return BottomNavigationBarItem(
              icon: Icon(menu.icon),
              label: menu.title
            );            
          }

          return BottomNavigationBarItem(
            icon: ProfileImageComponent(
              profileImage: null,
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
  IconData? icon;

  BottomMenuModel({
    required this.page,
    required this.title,
    this.icon,
  });
}