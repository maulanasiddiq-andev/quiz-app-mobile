import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final List<AdminPanelMenu> menus = [
    AdminPanelMenu(
      icon: Icons.person, 
      title: "User"
    ),
    AdminPanelMenu(
      icon: Icons.badge, 
      title: "Role"
    )
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Panel Admin"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...menus.map((menu) {
              return GestureDetector(
                onTap: () {
                  context.push("/${menu.title.toLowerCase()}");
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

  AdminPanelMenu({
    required this.icon,
    required this.title
  });
}