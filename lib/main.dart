import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/pages/auth/login_page.dart';
import 'package:quiz_app/pages/auth/otp_page.dart';
import 'package:quiz_app/pages/auth/register_page.dart';
import 'package:quiz_app/pages/quiz/quiz_detail_leaderboard_page.dart';
import 'package:quiz_app/pages/quiz/quiz_detail_page.dart';
import 'package:quiz_app/pages/quiz_create/quiz_create_review_page.dart';
import 'package:quiz_app/pages/quiz_create/quiz_detail_create_page.dart';
import 'package:quiz_app/pages/quiz_create/quiz_question_create_page.dart';
import 'package:quiz_app/pages/root_page.dart';
import 'package:quiz_app/pages/take_quiz/take_quiz_page.dart';
import 'package:quiz_app/pages/take_quiz/take_quiz_result_page.dart';
import 'package:quiz_app/splash_page.dart';
import 'package:quiz_app/theme/app_theme.dart';

Future<void> main() async {
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
    GoRoute(
      path: "/",
      builder: (context, state) => RootPage(),
    ),
    GoRoute(
      path: "/detail/:id",
      builder: (context, state) {
        final quizId = state.pathParameters['id'];
        return QuizDetailPage(quizId: quizId!);
      },
    ),
    GoRoute(
      path: "/detail-leaderboard/:id",
      builder: (context, state) {
        final quizId = state.pathParameters['id'];
        return QuizDetailLeaderboardPage(quizId: quizId!);
      },
    ),
    GoRoute(
      path: "/take-quiz",
      builder: (context, state) => TakeQuizPage(),
    ),
    GoRoute(
      path: "/take-quiz-result",
      builder: (context, state) => TakeQuizResultPage(),
    ),
    GoRoute(
      path: "/create-quiz",
      builder: (context, state) => QuizDetailCreatePage(),
    ),
    GoRoute(
      path: "/create-quiz-questions",
      builder: (context, state) => QuizQuestionCreatePage(),
    ),
    GoRoute(
      path: "/create-quiz-review",
      builder: (context, state) => QuizCreateReviewPage(),
    ),
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
