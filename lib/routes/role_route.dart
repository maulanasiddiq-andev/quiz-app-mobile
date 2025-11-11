import 'package:go_router/go_router.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/pages/admin/role/role_create_page.dart';
import 'package:quiz_app/pages/admin/role/role_detail_page.dart';
import 'package:quiz_app/pages/admin/role/role_edit_page.dart';
import 'package:quiz_app/pages/admin/role/role_list_page.dart';

final GoRoute roleRoute = GoRoute(
  path: "/${ResourceConstant.role}",
  builder: (context, state) => RoleListPage(),
  routes: [
    GoRoute(
      path: ActionConstant.create,
      builder: (context, state) => RoleCreatePage(),
    ),
    GoRoute(
      path: "${ActionConstant.detail}/:id",
      builder: (context, state) {
        final roleId = state.pathParameters['id'];
        return RoleDetailPage(roleId: roleId!);
      },
    ),
    GoRoute(
      path: "${ActionConstant.edit}/:id",
      builder: (context, state) {
        final roleId = state.pathParameters['id'];
        return RoleEditPage(roleId: roleId!);
      },
    ),
  ]
);
