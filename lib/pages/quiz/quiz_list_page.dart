import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/profile_image_component.dart';
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
  void initState() {
    super.initState();

    Future.microtask(() => ref.read(quizListProvider.notifier).getDatas());
  }

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
                    
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => QuizDetailPage(quizId: quiz.quizId)),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: colors.onSurface),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Text(quiz.title, style: TextStyle(fontSize: 18)),
                                  Text("Dikerjakan: ${quiz.historiesCount} kali"),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    spacing: 5,
                                    children: [
                                      Text("Oleh:"),
                                      ProfileImageComponent(
                                        radius: 10,
                                      ),
                                      Text(quiz.user.name)
                                    ],
                                  )
                                ],
                              ),
                            ),
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
