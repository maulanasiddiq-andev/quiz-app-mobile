import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Riwayat Kuis"),
      body: ConnectionCheckComponent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(
                        widget.quizHistory.user?.name ?? "user",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                      Text("Jawaban benar: ${widget.quizHistory.trueAnswers} dari ${widget.quizHistory.questionCount}"),
                      Text("Durasi pengerjaan: ${formatTime(widget.quizHistory.duration)}"),
                      Text("Nilai: ${widget.quizHistory.score}"),
                      Center(
                        child: SizedBox(
                          width: 300,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    color: colors.primary,
                                    value: widget.quizHistory.trueAnswers / widget.quizHistory.questionCount * 100,
                                    title: "Benar",
                                    radius: 80,
                                    titleStyle: TextStyle(
                                      fontSize: 16,
                                      color: colors.onPrimary
                                    )
                                  ),
                                  PieChartSectionData(
                                    color: colors.error,
                                    value: widget.quizHistory.wrongAnswers / widget.quizHistory.questionCount * 100,
                                    title: "Salah",
                                    radius: 80,
                                    titleStyle: TextStyle(
                                      fontSize: 16,
                                      color: colors.onError
                                    )
                                  ),
                                ]
                              )
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: CustomButtonComponent(
                onTap: () {
                  if (state.isLoading == false && state.questions.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizHistoryReviewPage(),
                      ),
                    );
                  }
                }, 
                text: "Review",
                isLoading: state.isLoading,
              )
            )
          ],
        ),
      ),
    );
  }
}