import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/notifiers/quiz/quiz_detail_leaderboard_notifier.dart';
import 'package:quiz_app/pages/quiz_history/quiz_history_detail_page.dart';
import 'package:quiz_app/styles/text_style.dart';
import 'package:quiz_app/utils/format_time.dart';

class QuizDetailLeaderboardPage extends ConsumerStatefulWidget {
  final String quizId;
  const QuizDetailLeaderboardPage({super.key, required this.quizId});

  @override
  ConsumerState<QuizDetailLeaderboardPage> createState() => _QuizDetailLeaderboardPageState();
}

class _QuizDetailLeaderboardPageState extends ConsumerState<QuizDetailLeaderboardPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) {
        final notifier = ref.read(quizDetailLeaderBoardProvider(widget.quizId).notifier);
        notifier.loadMoreDatas();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizDetailLeaderBoardProvider(widget.quizId));
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Leaderboard"),
      body: state.isLoading
        ? Center(
            child: CircularProgressIndicator(color: colors.primary),
          )
        : ListView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            children: [
              SizedBox(height: 5),
              if (state.histories.isEmpty)
                Center(
                  child: Text(
                    "Kuis belum dikerjakan",
                    style: CustomTextStyle.defaultTextStyle,
                  ),
                ),
              ...state.histories.map((history) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Container(
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
                            builder: (context) => QuizHistoryDetailPage(quizHistoryId: history.quizHistoryId),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Text(
                            history.quiz!.title, // quiz must be included from the backend
                            style: CustomTextStyle.defaultBoldTextStyle,
                          ),
                          Row(
                            spacing: 5,
                            children: [
                              ProfileImageComponent(
                                radius: 10,
                                profileImage: history.user?.profileImage,
                              ),
                              Text(
                                history.user?.name ?? "user",
                                style: CustomTextStyle.defaultTextStyle,
                              ),
                            ],
                          ),
                          Text(
                            "Nilai: ${history.score.toString()}",
                              style: CustomTextStyle.defaultTextStyle,
                          ),
                          Text(
                            "Durasi: ${formatTime(history.duration)}",
                              style: CustomTextStyle.defaultTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: 5),
              if (state.isLoadingMore)
                Center(
                  child: CircularProgressIndicator(color: colors.primary),
                )
            ],
          ),
    );
  }
}