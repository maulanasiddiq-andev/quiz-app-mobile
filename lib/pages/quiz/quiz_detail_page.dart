import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/notifiers/auth_notifier.dart';
import 'package:quiz_app/notifiers/quiz/quiz_detail_notifier.dart';
import 'package:quiz_app/notifiers/quiz/take_quiz_notifier.dart';
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
    final notifier = ref.read(quizDetailProvider(widget.quizId).notifier);
    final authState = ref.watch(authProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Detail Kuis"),
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
                          Text(
                            "Dikerjakan: ${state.quiz?.historiesCount ?? 0} kali",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      context.push("/detail-leaderboard/${widget.quizId}");
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.onSurface),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        "Leaderboard",
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                    ),
                  ),
                ),
                if (state.quiz?.userId == authState.token?.user?.userId)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: CustomButtonComponent(
                            isLoading: state.isLoadingDelete,
                            onTap: () async {
                              final result = await notifier.deleteQuiz(widget.quizId);

                              if (result == true && context.mounted) {
                                context.pop(state.quiz);
                              }
                            },
                            text: "Hapus",
                            isError: true,
                          ),
                        ),
                        Expanded(
                          child: CustomButtonComponent(
                            isLoading: ref.watch(takeQuizProvider).isLoading,
                            onTap: () {
                          
                            },
                            text: "Edit",
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  if (state.quiz!.isTakenByUser == false)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: CustomButtonComponent(
                        isLoading: ref.watch(takeQuizProvider).isLoading,
                        onTap: () async {
                          var result = await ref
                              .read(takeQuizProvider.notifier)
                              .getQuizWithQuestions(state.quiz!);
            
                          if (result == true && context.mounted) {
                            context.push("/take-quiz");
                          }
                        },
                        text: "Mulai",
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Center(
                        child: Text("Anda sudah mengerjakan kuis ini"),
                      ),
                    ),
              ],
            ),
      ),
    );
  }
}
