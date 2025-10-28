import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/quiz_container_component.dart';
import 'package:quiz_app/constants/sort_dir_constant.dart';
import 'package:quiz_app/notifiers/auth_notifier.dart';
import 'package:quiz_app/notifiers/quiz/quiz_list_notifier.dart';
import 'package:quiz_app/pages/auth/login_page.dart';
import 'package:quiz_app/pages/quiz/quiz_detail_page.dart';
import 'package:quiz_app/pages/quiz_create/quiz_detail_create_page.dart';
import 'package:shimmer/shimmer.dart';

class QuizListPage extends ConsumerStatefulWidget {
  const QuizListPage({super.key});

  @override
  ConsumerState<QuizListPage> createState() => _QuizListPageState();
}

class _QuizListPageState extends ConsumerState<QuizListPage> {
  // for searching quiz
  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

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
            spacing: 10,
            children: [
              SizedBox(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.onSurface),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextField(
                          onChanged: (value) {
                            if (debounce?.isActive ?? false) debounce!.cancel();

                            // Start a new 1-second timer
                            debounce = Timer(const Duration(seconds: 1), () async {
                              notifier.searchQuizzes(value);
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: "Cari judul kuis"
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (state.sortDir == SortDirConstant.asc) {
                          notifier.changeSortDir(SortDirConstant.desc);
                        } else {
                          notifier.changeSortDir(SortDirConstant.asc);
                        }
                      }, 
                      icon: Icon(Icons.sort)
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        for (var i = 0; i < 3; i++)
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300, 
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: 33,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                              ),
                            ), 
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
                        horizontal: 10,
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
