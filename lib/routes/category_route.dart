import 'package:go_router/go_router.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/pages/category/category_add_page.dart';
import 'package:quiz_app/pages/category/category_detail_page.dart';
import 'package:quiz_app/pages/category/category_edit_page.dart';

final List<GoRoute> categoryRoutes = [
  GoRoute(
    path: "/${ResourceConstant.category}/${ActionConstant.create}",
    builder: (context, state) => CategoryAddPage(),
  ),
  GoRoute(
    path: "/${ResourceConstant.category}/${ActionConstant.detail}/:id",
    builder: (context, state) {
      final categoryId = state.pathParameters['id'];
      return CategoryDetailPage(categoryId: categoryId!);
    },
  ),
  GoRoute(
    path: "/${ResourceConstant.category}/${ActionConstant.edit}/:id",
    builder: (context, state) {
      final categoryId = state.pathParameters['id'];
      return CategoryEditPage(categoryId: categoryId!);
    },
  ),
];