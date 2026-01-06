import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/check_module_component.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/quiz_container_component.dart';
import 'package:quiz_app/components/search_sort_component.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/module_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/notifiers/auth_notifier.dart';
import 'package:quiz_app/notifiers/quiz/quiz_list_notifier.dart';
import 'package:shimmer/shimmer.dart';

class QuizListPage extends ConsumerStatefulWidget {
  const QuizListPage({super.key});

  @override
  ConsumerState<QuizListPage> createState() => _QuizListPageState();
}

class _QuizListPageState extends ConsumerState<QuizListPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) {
        final notifier = ref.read(quizListProvider.notifier);
        notifier.loadMoreQuizzes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final state = ref.watch(quizListProvider);
    final notifier = ref.read(quizListProvider.notifier);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbarComponent(
        title: "Daftar Kuis",
        actions: [
          if (authState.isLoadingLogout)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SizedBox(
                width: 16,
                height: 16,
                child: Center(
                  child: CircularProgressIndicator(
                    color: colors.onPrimary,
                    strokeWidth: 2,  
                  ),
                ),
              ),
            )
          else
            IconButton(
              onPressed: () async {
                final result = await ref.read(authProvider.notifier).logout();

                if (result == true && context.mounted) {
                  context.go("/login");
                }
              }, 
              icon: Icon(Icons.logout)
            )
        ],  
      ),
      body: ConnectionCheckComponent(
        child: RefreshIndicator(
          onRefresh: () => ref.read(quizListProvider.notifier).refreshQuizzes(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              SizedBox(),
              SearchSortComponent(
                feature: "kuis",
                search: state.search, 
                sortDir: state.sortDir, 
                onSearchChanged: (value) {
                  notifier.searchQuizzes(value);
                },
                onSortDirChanged: (value) {
                  notifier.changeSortDir(value);
                },
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
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: scrollController,
                        children: [
                          ...state.quizzes.map((quiz) {
                            return QuizContainerComponent(
                              onTap: () async {
                                final result = await context.push("/${ResourceConstant.quiz}/${ActionConstant.detail}/${quiz.quizId}");

                                // if the delete succeed in detail page
                                // remove the quiz from the list
                                if (result != null && result is QuizModel) {
                                  notifier.removeQuizByIdFromList(result);
                                }
                              },
                              quiz: quiz,
                            ); 
                          }),
                          if (state.isLoadingMoreQuizzes)
                            Center(
                              child: CircularProgressIndicator(color: colors.primary),
                            )
                        ]
                      ),
                  ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CheckModuleComponent(
        moduleNames: [ModuleConstant.createCategory],
        child: FloatingActionButton(
          heroTag: "quizFab",
          onPressed: () {
            context.push("/${ResourceConstant.quiz}/${ActionConstant.create}");
          },
          child: Icon(Icons.create),
        ),
      ),
    );
  }
}
