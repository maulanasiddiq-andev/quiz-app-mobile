import 'package:flutter/material.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/pages/admin/user/user_list_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final List<AdminPanelMenu> menus = [
    AdminPanelMenu(
      page: UserListPage(), 
      icon: Icons.person, 
      title: "User"
    ),
    AdminPanelMenu(
      page: UserListPage(), 
      icon: Icons.badge, 
      title: "Role"
    )
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: customAppbarComponent(
        "Panel Admin",
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...menus.map((menu) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => menu.page)
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: colors.onSurface)
                    )
                  ),
                  child: Row(
                    spacing: 20,
                    children: [
                      Icon(menu.icon, size: 30),
                      Text(
                        menu.title,
                        style: TextStyle(
                          fontSize: 20
                        ),  
                      )
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

class AdminPanelMenu {
  final IconData icon;
  final String title;
  final Widget page;

  AdminPanelMenu({
    required this.page,
    required this.icon,
    required this.title
  });
}