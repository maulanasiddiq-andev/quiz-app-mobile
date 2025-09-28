import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/notifiers/quiz/quiz_detail_notifier.dart';
import 'package:quiz_app/pages/quiz/quiz_exam_page.dart';

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
      appBar: customAppbarComponent("Quiz Detail"),
      body: state.isLoading
        ? Center(
            child: CircularProgressIndicator(color: Colors.blue),
          )
        : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.quiz?.title ?? "Judul Kuis",
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                        Text(
                          state.quiz?.description ?? "Deskripsi Kuis",
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuizExamPage(quiz: state.quiz!),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                        'Mulai',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ),
                )
              )
            ],
          ),
    );
  }
}