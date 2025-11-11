import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/confirm_dialog.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/notifiers/auth_notifier.dart';
import 'package:quiz_app/notifiers/quiz/quiz_detail_notifier.dart';
import 'package:quiz_app/notifiers/quiz/take_quiz_notifier.dart';
import 'package:quiz_app/styles/text_style.dart';
import 'package:quiz_app/utils/format_date.dart';
import 'package:quiz_app/utils/format_time.dart';

class QuizDetailPage extends ConsumerStatefulWidget {
  final String quizId;
  const QuizDetailPage({super.key, required this.quizId});

  @override
  ConsumerState<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends ConsumerState<QuizDetailPage> {
  Future<bool> confirmDelete() async {
    final result = confirmDialog(
      context: context, 
      title: "Perhatian", 
      content: "Apakah anda yakin ingin menghapus kuis ini?"
    );

    return result;
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Text(
                            state.quiz?.title ?? "Judul Kuis",
                            style: CustomTextStyle.headerStyle,
                          ),
                          // user is always included while getting quiz detail
                          if (state.quiz?.user != null)
                            Row(
                              spacing: 5,
                              children: [
                                Text(
                                  "Oleh:",
                                  style: CustomTextStyle.defaultTextStyle,
                                ),
                                ProfileImageComponent(profileImage: state.quiz?.user?.profileImage),
                                Text(
                                  state.quiz!.user!.name,
                                  style: CustomTextStyle.defaultTextStyle,
                                ),

                              ],
                            ),
                          Text(
                            "Dibuat pada ${formatDate(state.quiz?.modifiedTime)}",
                            style: CustomTextStyle.defaultTextStyle,
                          ),
                          if (state.quiz?.imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(10),
                              child: Image.network(
                                state.quiz!.imageUrl!,
                                width: double.infinity,
                              ),
                            ),
                          Text(
                            state.quiz?.description ?? "Deskripsi Kuis",
                            style: CustomTextStyle.defaultTextStyle,
                          ),
                          Divider(),
                          Text(
                            "Jumlah Pertanyaan: ${state.quiz?.questionCount ?? 0}",
                            style: CustomTextStyle.defaultTextStyle,
                          ),
                          Text(
                            "Waktu pengerjaan: ${formatTime(state.quiz?.time == null ? 0 : state.quiz!.time * 60)}",
                            style: CustomTextStyle.defaultTextStyle,
                          ),
                          Text(
                            "Dikerjakan: ${state.quiz?.historiesCount ?? 0} kali",
                            style: CustomTextStyle.defaultTextStyle,
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
                      context.push("/${ResourceConstant.quiz}/${ActionConstant.detail}/${widget.quizId}/${ActionConstant.leaderboard}");
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
                        style: CustomTextStyle.defaultTextStyle,
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
                              final deleteConfirmed = await confirmDelete();

                              if (deleteConfirmed) {
                                final result = await notifier.deleteQuiz(widget.quizId);

                                if (result == true && context.mounted) {
                                  context.pop(state.quiz);
                                } 
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
                            context.push("/${ResourceConstant.quiz}/${ActionConstant.detail}/${widget.quizId}/${ActionConstant.take}");
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
