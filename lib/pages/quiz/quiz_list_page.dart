import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers/quiz/quiz_list_notifier.dart';

class QuizListPage extends ConsumerStatefulWidget {
  const QuizListPage({super.key});

  @override
  ConsumerState<QuizListPage> createState() => _QuizListPageState();
}

class _QuizListPageState extends ConsumerState<QuizListPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => ref.read(quizProvider.notifier).getDatas());
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz List"),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(quizProvider.notifier).refreshDatas(),
        child: state.isLoading
        ? Center(
            child: CircularProgressIndicator(color: Colors.blue),
          )
        : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemCount: state.quizzes.length,
            itemBuilder: (context, index) {
              final quiz = state.quizzes[index];

              return Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  quiz.title,
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              );
            }
          ), 
      ),
    );
  }
}