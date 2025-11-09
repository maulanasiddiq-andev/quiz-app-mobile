import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/notifiers/quiz/take_quiz_notifier.dart';
import 'package:quiz_app/styles/text_style.dart';
import 'package:quiz_app/utils/format_time.dart';

class TakeQuizResultPage extends ConsumerStatefulWidget {
  const TakeQuizResultPage({super.key});

  @override
  ConsumerState<TakeQuizResultPage> createState() => _TakeQuizResultPageState();
}

class _TakeQuizResultPageState extends ConsumerState<TakeQuizResultPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(takeQuizProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // navigate back three times for reaching quiz list page
          context.go("/${ResourceConstant.quiz}");
        }
      },
      child: Scaffold(
        appBar: CustomAppbarComponent(title: "Hasil Kuis"),
        body: ConnectionCheckComponent(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(
                        "Jawaban benar: ${state.quizHistory!.trueAnswers}",
                        style: CustomTextStyle.defaultTextStyle,
                      ),
                      Text(
                        "Nilai: ${state.quizHistory!.score}",
                        style: CustomTextStyle.defaultTextStyle,
                      ),
                      Text(
                        "Durasi Pengerjaan: ${formatTime(state.quizHistory!.duration)}",
                        style: CustomTextStyle.defaultTextStyle,
                      ),
                    ],
                  ),
                ),
                CustomButtonComponent(
                  onTap: () {
                    context.go("/${ResourceConstant.quiz}");
                  },
                  text: "Kembali",
                ),
                SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
