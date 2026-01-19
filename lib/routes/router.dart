// routing with go
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/notifiers/auth_notifier.dart';
import 'package:quiz_app/pages/auth/change_email_page.dart';
import 'package:quiz_app/pages/auth/login_page.dart';
import 'package:quiz_app/pages/auth/otp_page.dart';
import 'package:quiz_app/pages/auth/register_page.dart';
import 'package:quiz_app/pages/root_page.dart';
import 'package:quiz_app/routes/admin_route.dart';
import 'package:quiz_app/routes/category_route.dart';
import 'package:quiz_app/routes/profile_route.dart';
import 'package:quiz_app/routes/quiz_route.dart';
import 'package:quiz_app/splash_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: "/splash",
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final path = state.matchedLocation;

      if (authState.isCheckAuthLoading) {
        return '/splash';
      }

      if (path == '/splash') {
        return isAuthenticated ? '/quiz' : '/login';
      }

      if (!isAuthenticated && path != '/login') {
        return '/login';
      }

      if (isAuthenticated && path == '/login') {
        return '/quiz';
      }

      return null;
    },
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

      // shell for authenticated pages
      ShellRoute(
        builder: (context, state, child) {
          return RootPage(child: child);
        },
        routes: [
          quizRoute,
          categoryRoute,
          adminRoute,
          profileRoute
        ]
      )
    ],
  );
});