import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/pages/auth/login_page.dart';
import 'package:quiz_app/pages/auth/otp_page.dart';
import 'package:quiz_app/pages/auth/register_page.dart';
import 'package:quiz_app/routes/category_route.dart';
import 'package:quiz_app/routes/quiz_route.dart';
import 'package:quiz_app/routes/role_route.dart';
import 'package:quiz_app/routes/user_route.dart';
import 'package:quiz_app/services/firebase_messaging_service.dart';
import 'package:quiz_app/splash_page.dart';
import 'package:quiz_app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseMessagingService.initNotifications();

  runApp(const ProviderScope(child: MyApp()));
}

// routing with go
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Everyday Quiz',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
