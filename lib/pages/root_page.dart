import 'package:flutter/material.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/pages/profile/profile_page.dart';
import 'package:quiz_app/pages/quiz/quiz_list_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [QuizListPage(), ProfilePage()];
  final List<BottomMenuModel> menus = [
    BottomMenuModel(
      title: 'Beranda',
      icon: Icons.home,
    ),
    BottomMenuModel(
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
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
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
  String title;
  IconData? icon;

  BottomMenuModel({
    required this.title,
    this.icon,
  });
}