import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers/quiz/quiz_detail_notifier.dart';

class QuizDetailPage extends ConsumerStatefulWidget {
  final String quizId;
  const QuizDetailPage({super.key, required this.quizId});

  @override
  ConsumerState<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends ConsumerState<QuizDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => ref.read(quizDetailProvider.notifier).getQuizById(widget.quizId));
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizDetailProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Detail"),
      ),
      body: state.isLoading
        ? Center(
            child: CircularProgressIndicator(color: Colors.blue),
          )
        : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(state.quiz?.title ?? "Judul Kuis")
                    ],
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.all(10)
              )
            ],
          ),
    );
  }
}