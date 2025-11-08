import 'package:go_router/go_router.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/pages/category/category_add_page.dart';
import 'package:quiz_app/pages/category/category_detail_page.dart';
import 'package:quiz_app/pages/category/category_edit_page.dart';
import 'package:quiz_app/pages/category/category_list_page.dart';

final GoRoute categoryRoute = GoRoute(
  path: "/${ResourceConstant.category}",
  builder: (context, state) => CategoryListPage(),
  routes: [
    GoRoute(
      path: ActionConstant.create,
      builder: (context, state) => CategoryAddPage(),
    ),
    GoRoute(
      path: "${ActionConstant.detail}/:id",
      builder: (context, state) {
        final categoryId = state.pathParameters['id'];
        return CategoryDetailPage(categoryId: categoryId!);
      },
    ),
    GoRoute(
      path: "${ActionConstant.edit}/:id",
      builder: (context, state) {
        final categoryId = state.pathParameters['id'];
        return CategoryEditPage(categoryId: categoryId!);
      },
    ),
  ]
);