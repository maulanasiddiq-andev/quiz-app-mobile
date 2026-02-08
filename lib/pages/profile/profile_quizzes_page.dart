import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/quiz_container_component.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/notifiers/profile/profile_quizzes_notifier.dart';

class ProfileQuizzesPage extends ConsumerStatefulWidget {
  const ProfileQuizzesPage({super.key});

  @override
  ConsumerState<ProfileQuizzesPage> createState() => _ProfileQuizzesPageState();
}

class _ProfileQuizzesPageState extends ConsumerState<ProfileQuizzesPage> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(profileQuizzesProvider);
    return Scaffold(
      appBar: CustomAppbarComponent(title: "Kuis Dibuat ${!state.isLoading && !state.isLoadingMore ? '(${state.quizzes.length})' : ''}"),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(profileQuizzesProvider.notifier).refreshQuizzes();
        },
        child: state.isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        : state.quizzes.isEmpty
          ? Center(
              child: Text("Belum ada kuis yang dibuat"),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  ...state.quizzes.map((quiz) {
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: QuizContainerComponent(
                            onTap: () async {
                              final result = await context.push("/${ResourceConstant.quiz}/${ActionConstant.detail}/${quiz.quizId}");
                                      
                              // if the delete succeed in detail page
                              // remove the quiz from the list
                              if (result != null && result is QuizModel) {
                                // ref.read(profileQuizzesProvider.notifier).removeQuizByIdFromList(result);
                              }
                            },
                            quiz: quiz,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ); 
                  }),
                ],
              ),
            ),
      ),
    );
  }
}