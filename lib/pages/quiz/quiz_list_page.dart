import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                (route) => false
              );
            }, 
            icon: Icon(Icons.logout)
          )
        ],
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(quizListProvider.notifier).refreshDatas(),
        child: state.isLoading
            ? Center(child: CircularProgressIndicator(color: colors.primary))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        itemCount: state.quizzes.length,
                        itemBuilder: (context, index) {
                          final quiz = state.quizzes[index];
                    
                          return QuizContainerComponent(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => QuizDetailPage(quizId: quiz.quizId))
                              );
                            }, 
                            quiz: quiz
                          );
                        },
                      ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => QuizDetailCreatePage()
                        )
                      );
                    }, 
                    child: Text("Buat Kuis")
                  )
                ],
              ),
      ),
    );
  }
}
