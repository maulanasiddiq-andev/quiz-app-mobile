// routing with go
import 'package:go_router/go_router.dart';
import 'package:quiz_app/pages/auth/change_email_page.dart';
import 'package:quiz_app/pages/auth/login_page.dart';
import 'package:quiz_app/pages/auth/otp_page.dart';
import 'package:quiz_app/pages/auth/register_page.dart';
import 'package:quiz_app/routes/category_route.dart';
import 'package:quiz_app/routes/quiz_route.dart';
import 'package:quiz_app/routes/role_route.dart';
import 'package:quiz_app/routes/user_route.dart';
import 'package:quiz_app/splash_page.dart';

final GoRouter router = GoRouter(
  initialLocation: "/splash",
  routes: [
    GoRoute(
      path: "/splash",
      builder: (context, state) => SplashPage(),
    ),
    // unauthenticated pages
    GoRoute(
      path: "/login",
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: "/register",
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: "/otp",
      builder: (context, state) => OtpPage(),
    ),
    GoRoute(
      path: "/change-email",
      builder: (context, state) => ChangeEmailPage(),
    ),
    // authenticated pages
    // quiz
    quizRoute,
    // category pages
    categoryRoute,
    // role routes
    roleRoute,
    // user pages
    userRoute
  ]
);