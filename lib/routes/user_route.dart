import 'package:go_router/go_router.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/pages/admin/user/user_detail_page.dart';
import 'package:quiz_app/pages/admin/user/user_edit_page.dart';
import 'package:quiz_app/pages/admin/user/user_list_page.dart';

final GoRoute userRoute = GoRoute(
  path: "/${ResourceConstant.user}",
  builder: (context, state) => UserListPage(),
  routes: [
    GoRoute(
      path: "${ActionConstant.detail}/:id",
      builder: (context, state) {
        final userId = state.pathParameters['id'];
        return UserDetailPage(userId: userId!);
      },
    ),
    GoRoute(
      path: "${ActionConstant.edit}/:id",
      builder: (context, state) {
        final userId = state.pathParameters['id'];
        return UserEditPage(userId: userId!);
      },
    ),
  ]
);