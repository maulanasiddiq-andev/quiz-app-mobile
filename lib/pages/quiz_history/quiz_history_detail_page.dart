import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';
import 'package:quiz_app/notifiers/quiz_history/quiz_history_detail_notifier.dart';
import 'package:quiz_app/pages/quiz_history/quiz_history_review_page.dart';
import 'package:quiz_app/utils/format_time.dart';

class QuizHistoryDetailPage extends ConsumerStatefulWidget {
  final QuizHistoryModel quizHistory;
  const QuizHistoryDetailPage({super.key, required this.quizHistory});

  @override
  ConsumerState<QuizHistoryDetailPage> createState() => _QuizHistoryDetailPageState();
}

class _QuizHistoryDetailPageState extends ConsumerState<QuizHistoryDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => ref.read(quizHistoryDetailProvider.notifier).getQuizHistoryById(widget.quizHistory.quizHistoryId));
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizHistoryDetailProvider);

    return Scaffold(
      appBar: customAppbarComponent("Riwayat"),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    widget.quizHistory.user.name,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Text("Jawaban benar: ${widget.quizHistory.trueAnswers} dari ${widget.quizHistory.questionCount}"),
                  Text("Durasi pengerjaan: ${formatTime(widget.quizHistory.duration)}"),
                  Text("Nilai: ${widget.quizHistory.score}")
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  if (state.isLoading == false && state.currentQuestion != null) {
                    
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizHistoryReviewPage(),
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
                    child: state.isLoading 
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Review',
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
      ),
    );
  }
}