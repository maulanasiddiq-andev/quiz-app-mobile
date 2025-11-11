import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/notifiers/quiz_history/quiz_history_detail_notifier.dart';
import 'package:quiz_app/pages/quiz_history/quiz_history_review_page.dart';
import 'package:quiz_app/styles/text_style.dart';
import 'package:quiz_app/utils/format_date.dart';
import 'package:quiz_app/utils/format_time.dart';

class QuizHistoryDetailPage extends ConsumerStatefulWidget {
  final String quizHistoryId;
  const QuizHistoryDetailPage({super.key, required this.quizHistoryId});

  @override
  ConsumerState<QuizHistoryDetailPage> createState() => _QuizHistoryDetailPageState();
}

class _QuizHistoryDetailPageState extends ConsumerState<QuizHistoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizHistoryDetailProvider(widget.quizHistoryId));
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Riwayat Kuis"),
      body: ConnectionCheckComponent(
        child: state.isLoading || state.quizHistory == null
        ? Center(
            child: CircularProgressIndicator(color: colors.primary),
          )
        : Column(
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
                        state.quizHistory?.quiz?.title ?? 'Kuis',
                        style: CustomTextStyle.headerStyle,  
                      ),
                      Text(
                        "Dikerjakan oleh: ${state.quizHistory?.user?.name ?? 'user'}",
                        style: CustomTextStyle.defaultTextStyle,  
                      ),
                      Text(
                        "Dikerjakan pada: ${formatDate(state.quizHistory?.createdTime)}",
                        style: CustomTextStyle.defaultTextStyle,  
                      ),
                      Text(
                        "Jawaban benar: ${state.quizHistory?.trueAnswers} dari ${state.quizHistory?.questionCount}",
                        style: CustomTextStyle.defaultTextStyle,  
                      ),
                      Text(
                        "Durasi pengerjaan: ${formatTime(state.quizHistory?.duration)}",
                        style: CustomTextStyle.defaultTextStyle,
                      ),
                      Text(
                        "Nilai: ${state.quizHistory?.score}",
                        style: CustomTextStyle.defaultTextStyle,
                      ),
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
                                    value: (state.quizHistory?.trueAnswers ?? 0) / (state.quizHistory?.questionCount ?? 0) * 100,
                                    title: "Benar",
                                    radius: 80,
                                    titleStyle: TextStyle(
                                      fontSize: 16,
                                      color: colors.onPrimary
                                    )
                                  ),
                                  PieChartSectionData(
                                    color: colors.error,
                                    value: (state.quizHistory?.wrongAnswers ?? 0) / (state.quizHistory?.questionCount ?? 0) * 100,
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
            if (state.quizHistory != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: CustomButtonComponent(
                  onTap: () {
                    if (state.isLoading == false && state.quizHistory!.questions.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizHistoryReviewPage(quizHistoryId: widget.quizHistoryId),
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