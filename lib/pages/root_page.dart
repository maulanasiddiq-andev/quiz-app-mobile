import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/confirm_dialog.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/constants/module_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/models/identity/role_module_model.dart';
import 'package:quiz_app/notifiers/auth_notifier.dart';

class RootPage extends ConsumerStatefulWidget {
  final Widget child;
  const RootPage({super.key, required this.child});

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  final List<BottomMenuModel> menus = [
    BottomMenuModel(
      title: 'Beranda',
      icon: Icons.home,
      moduleNames: [ModuleConstant.searchQuiz],
      path: "/${ResourceConstant.quiz}"
    ),
    BottomMenuModel(
      title: 'Kategori',
      icon: Icons.category,
      moduleNames: [ModuleConstant.searchCategory, ModuleConstant.detailCategory],
      path: "/${ResourceConstant.category}"
    ),
    BottomMenuModel(
      title: 'Admin',
      icon: Icons.admin_panel_settings,
      moduleNames: [ModuleConstant.searchUser, ModuleConstant.searchRole],
      path: "/admin"
    ),
    BottomMenuModel(
      title: 'Profile',
      moduleNames: [],
      path: "/profile"
    )
  ];

  List<BottomMenuModel> visibleMenus(List<RoleModuleModel>? modules) {
    return menus
      .where((menu) => modules != null && menu.moduleNames.every((moduleName) => modules.any((module) => module.roleModuleName == moduleName)))
      .toList();
  }

  Future<bool> confirmExit() async {
    final result = confirmDialog(
      context: context, 
      title: "Perhatian", 
      content: "Apakah Anda yakin ingin keluar dari aplikasi ini?"
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    
    final state = ref.watch(authProvider);
    final modules = state.token?.user?.role?.roleModules;
    final colors = Theme.of(context).colorScheme;

    final shownMenus = visibleMenus(modules);
    int index = shownMenus.indexWhere((menu) => location.startsWith(menu.path));

    // fallback if user deep-links to hidden tab
    if (index == -1) {
      index = 0;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final exitConfirmed = await confirmExit();

          if (exitConfirmed && context.mounted) {
            SystemNavigator.pop();
          }
        }

        return;
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: colors.primary,
          selectedItemColor: colors.onPrimary,
          currentIndex: index,
          onTap: (value) {
            context.go(shownMenus[value].path);
          },
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
      ),
    );
  }
}

class BottomMenuModel {
  String title;
  List<String> moduleNames;
  String path;
  IconData? icon;

  BottomMenuModel({
    required this.title,
    required this.moduleNames,
    required this.path,
    this.icon,
  });
}