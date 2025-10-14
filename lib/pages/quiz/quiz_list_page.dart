import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/quiz_container_component.dart';
import 'package:quiz_app/notifiers/auth_notifier.dart';
import 'package:quiz_app/notifiers/quiz/quiz_list_notifier.dart';
import 'package:quiz_app/pages/auth/login_page.dart';
import 'package:quiz_app/pages/quiz/quiz_detail_page.dart';
import 'package:quiz_app/pages/quiz_create/quiz_detail_create_page.dart';

class QuizListPage extends ConsumerStatefulWidget {
  const QuizListPage({super.key});

  @override
  ConsumerState<QuizListPage> createState() => _QuizListPageState();
}

class _QuizListPageState extends ConsumerState<QuizListPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizListProvider);
    final notifier = ref.read(quizListProvider.notifier);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: customAppbarComponent(
        "Quiz List",
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: ConnectionCheckComponent(
        child: RefreshIndicator(
          onRefresh: () => ref.read(quizListProvider.notifier).refreshQuizzes(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () => notifier.selectCategory(""),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colors.onSurface
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: state.selectedCategoryId == ""
                              ? colors.onSurface
                              : colors.surface
                          ),
                          child: Text(
                            "Semua",
                            style: TextStyle(
                              color: state.selectedCategoryId == "" 
                                ? colors.surface
                                : colors.onSurface
                            ),
                          )
                        ),
                      ),
                      if (state.isLoadingCategories)
                        SizedBox(
                          child: CircularProgressIndicator(
                            color: colors.primary,
                          )
                        )
                      else
                        ...state.categories.map((category) {
                          return GestureDetector(
                            onTap: () => notifier.selectCategory(category.categoryId),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colors.onSurface
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: state.selectedCategoryId == category.categoryId
                                  ? colors.onSurface
                                  : colors.surface
                              ),
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  color: state.selectedCategoryId == category.categoryId 
                                    ? colors.surface
                                    : colors.onSurface
                                ),
                              )
                            ),
                          );
                        })
                    ],
                  ),
                ),
              ),
              Expanded(
                child: state.isLoadingQuizzes
                  ? Center(
                      child: CircularProgressIndicator(color: colors.primary),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      itemCount: state.quizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = state.quizzes[index];
        
                        return QuizContainerComponent(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuizDetailPage(quizId: quiz.quizId),
                              ),
                            );
                          },
                          quiz: quiz,
                        );
                      },
                    ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizDetailCreatePage(),
                    ),
                  );
                },
                child: Text("Buat Kuis"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
