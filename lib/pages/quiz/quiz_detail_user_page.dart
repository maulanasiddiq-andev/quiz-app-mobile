import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/components/quiz_container_component.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/notifiers/quiz/quiz_detail_user_notifier.dart';

class QuizDetailUserPage extends ConsumerStatefulWidget {
  final String userId;
  const QuizDetailUserPage({super.key, required this.userId});

  @override
  ConsumerState<QuizDetailUserPage> createState() => _QuizDetailUserPageState();
}

class _QuizDetailUserPageState extends ConsumerState<QuizDetailUserPage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) {
        final notifier = ref.read(quizDetailUserProvider(widget.userId).notifier);
        notifier.loadMoreQuizzes();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(quizDetailUserProvider(widget.userId));
    final notifier = ref.read(quizDetailUserProvider(widget.userId).notifier);
    var colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Creator"),
      body: RefreshIndicator(
        onRefresh: () async {
          notifier.refreshQuizzes();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          child: Column(
            spacing: 10,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                color: colors.primaryContainer,
                child: Row(
                  spacing: 10,
                  children: [
                    ProfileImageComponent(
                      profileImage: state.user?.profileImage,
                      radius: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.user?.name ?? "user",
                          style: TextStyle(
                            fontSize: 16,
                            color: colors.onPrimary,
                          ),  
                        ),
                        Text(
                          state.user?.email ?? "email",
                          style: TextStyle(
                            fontSize: 16,
                            color: colors.onPrimary,
                          ),  
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    ...state.quizzes.map((quiz) {
                      return SizedBox(
                        width: double.infinity,
                        child: QuizContainerComponent(
                          onTap: () async {
                            final result = await context.push("/${ResourceConstant.quiz}/${ActionConstant.detail}/${quiz.quizId}");
                        
                            // if the delete succeed in detail page
                            // remove the quiz from the list
                            if (result != null && result is QuizModel) {
                              // notifier.removeQuizByIdFromList(result);
                            }
                          },
                          quiz: quiz,
                        ),
                      ); 
                    }),
                    if (state.isLoadingMore)
                      Center(
                        child: CircularProgressIndicator(color: colors.primary),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}