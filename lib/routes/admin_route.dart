import 'package:go_router/go_router.dart';
import 'package:quiz_app/pages/admin/admin_page.dart';
import 'package:quiz_app/routes/role_route.dart';
import 'package:quiz_app/routes/user_route.dart';

final GoRoute adminRoute = GoRoute(
  path: "/admin",
  builder: (context, state) => AdminPage(),
  routes: [
    userRoute,
    roleRoute,
  ],
);