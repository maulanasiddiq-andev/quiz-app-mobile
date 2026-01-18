import 'package:go_router/go_router.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/pages/quiz/quiz_detail_leaderboard_page.dart';
import 'package:quiz_app/pages/quiz/quiz_detail_page.dart';
import 'package:quiz_app/pages/quiz/quiz_detail_user_page.dart';
import 'package:quiz_app/pages/quiz_create/quiz_create_review_page.dart';
import 'package:quiz_app/pages/quiz_create/quiz_detail_create_page.dart';
import 'package:quiz_app/pages/quiz_create/quiz_question_create_page.dart';
import 'package:quiz_app/pages/quiz_edit/quiz_edit_description_page.dart';
import 'package:quiz_app/pages/quiz_edit/quiz_edit_questions_page.dart';
import 'package:quiz_app/pages/quiz_edit/quiz_edit_review_page.dart';
import 'package:quiz_app/pages/root_page.dart';
import 'package:quiz_app/pages/take_quiz/take_quiz_page.dart';
import 'package:quiz_app/pages/take_quiz/take_quiz_result_page.dart';

final GoRoute quizRoute = GoRoute(
  path: "/${ResourceConstant.quiz}",
  builder: (context, state) => RootPage(),
  routes: [
    GoRoute(
      path: "${ActionConstant.detail}/:id",
      builder: (context, state) {
        final quizId = state.pathParameters['id'];
        return QuizDetailPage(quizId: quizId!);
      },
      routes: [
        GoRoute(
          path: ActionConstant.leaderboard,
          builder: (context, state) {
            final quizId = state.pathParameters['id'];
            return QuizDetailLeaderboardPage(quizId: quizId!);
          }
        ),
        // take quiz pages
        GoRoute(
          path: ActionConstant.take,
          builder: (context, state) => TakeQuizPage(),
          routes: [
            GoRoute(
              path: ActionConstant.result,
              builder: (context, state) => TakeQuizResultPage(),
            ),
          ]
        ),
      ]
    ),
    // update quiz
    GoRoute(
      path: '${ActionConstant.edit}/:id',
      builder: (context, state) {
        final quizId = state.pathParameters['id'];
        return QuizEditDescriptionPage(quizId: quizId!);
      },
      routes: [
        GoRoute(
          path: ResourceConstant.question,
          builder: (context, state) {
            final quizId = state.pathParameters['id'];
            return QuizEditQuestionsPage(quizId: quizId!);
          },
          routes: [
            GoRoute(
              path: ActionConstant.review,
              builder: (context, state) {
                final quizId = state.pathParameters['id'];
                return QuizEditReviewPage(quizId: quizId!);
              },
            ),
          ]
        ),
      ]
    ),
    // create quiz pages
    GoRoute(
      path: ActionConstant.create,
      builder: (context, state) => QuizDetailCreatePage(),
      routes: [
        GoRoute(
          path: ResourceConstant.question,
          builder: (context, state) => QuizQuestionCreatePage(),
          routes: [
            GoRoute(
              path: ActionConstant.review,
              builder: (context, state) => QuizCreateReviewPage(),
            ),
          ]
        ),
      ]
    ),
    // get quizzes by user
    GoRoute(
      path: "${ResourceConstant.user}/:id",
      builder: (context, state) {
        final userId = state.pathParameters["id"];
        return QuizDetailUserPage(userId: userId!);
      },
    )
  ]
);