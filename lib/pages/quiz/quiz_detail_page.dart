import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/notifiers/quiz/quiz_detail_notifier.dart';
import 'package:quiz_app/notifiers/quiz/take_quiz_notifier.dart';
import 'package:quiz_app/pages/take_quiz/take_quiz_page.dart';
import 'package:quiz_app/pages/quiz_history/quiz_history_detail_page.dart';
import 'package:quiz_app/utils/format_time.dart';

class QuizDetailPage extends ConsumerStatefulWidget {
  final String quizId;
  const QuizDetailPage({super.key, required this.quizId});

  @override
  ConsumerState<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends ConsumerState<QuizDetailPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        final notifier = ref.read(quizDetailProvider(widget.quizId).notifier);
        notifier.loadMoreHistories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizDetailProvider(widget.quizId));
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: customAppbarComponent(
        "Quiz Detail",
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: ConnectionCheckComponent(
        child: state.isLoading && state.quiz == null
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.quiz?.title ?? "Judul Kuis",
                            style: TextStyle(fontSize: 20),
                          ),
                          state.quiz?.imageUrl != null
                              ? Column(
                                  children: [
                                    SizedBox(height: 10),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(10),
                                      child: Image.network(
                                        state.quiz!.imageUrl!,
                                        width: double.infinity,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )
                              : SizedBox(height: 10),
                          Text(
                            state.quiz?.description ?? "Deskripsi Kuis",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Jumlah Pertanyaan: ${state.quiz?.questionCount ?? 0}",
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Waktu pengerjaan: ${formatTime(state.quiz?.time == null ? 0 : state.quiz!.time * 60)}",
                          ),
                          SizedBox(height: 10),
                          state.isLoadingHistories
                            ? CircularProgressIndicator(color: colors.primary)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  state.histories.isNotEmpty
                                    ? Text("Peserta Kuis")
                                    : SizedBox(),
                                  ...state.histories.map((history) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: colors.onSurface,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          5,
                                        ),
                                      ),
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => QuizHistoryDetailPage(quizHistory: history),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 5,
                                          children: [
                                            Row(
                                              spacing: 5,
                                              children: [
                                                ProfileImageComponent(
                                                  radius: 10,
                                                ),
                                                Text(
                                                  history.user?.name ??
                                                      "user",
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "Nilai: ${history.score.toString()}",
                                            ),
                                            Text(
                                              "Durasi: ${formatTime(history.duration)}",
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                  if (state.isLoadingMoreHistories)
                                    Center(
                                      child: CircularProgressIndicator(color: colors.primary),
                                    )
                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: CustomButtonComponent(
                    isLoading: ref.watch(takeQuizProvider).isLoading,
                    onTap: () async {
                      var result = await ref
                          .read(takeQuizProvider.notifier)
                          .getQuizWithQuestions(state.quiz!);
        
                      if (result == true && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TakeQuizPage(),
                          ),
                        );
                      }
                    },
                    text: "Mulai",
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
