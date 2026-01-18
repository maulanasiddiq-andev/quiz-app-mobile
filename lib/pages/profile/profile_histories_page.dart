import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/notifiers/profile/profile_histories_notifier.dart';
import 'package:quiz_app/pages/quiz_history/quiz_history_detail_page.dart';
import 'package:quiz_app/styles/text_style.dart';
import 'package:quiz_app/utils/format_time.dart';

class ProfileHistoriesPage extends ConsumerStatefulWidget {
  const ProfileHistoriesPage({super.key});

  @override
  ConsumerState<ProfileHistoriesPage> createState() => _ProfileHistoriesPageState();
}

class _ProfileHistoriesPageState extends ConsumerState<ProfileHistoriesPage> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(profileHistoriesProvider);
    var colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Kuis Dikerjakan ${!state.isLoading && !state.isLoadingMore ? '(${state.histories.length})' : ''}"),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(profileHistoriesProvider.notifier).refreshHistories();
        },
        child: state.isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        : state.histories.isEmpty
          ? Center(
              child: Text("Belum ada kuis yang dikerjakan"),
            )
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
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
              ],
            ),
      ),
    );
  }
}