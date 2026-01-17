import 'package:go_router/go_router.dart';
import 'package:quiz_app/pages/profile/profile_histories_page.dart';
import 'package:quiz_app/pages/profile/profile_quizzes_page.dart';

final List<GoRoute> profileRoute = [
  GoRoute(
    path: '/profile-history',
    builder: (context, state) => const ProfileHistoriesPage(),
  ),
  GoRoute(
    path: '/profile-quiz',
    builder: (context, state) => const ProfileQuizzesPage(),
  ),
];