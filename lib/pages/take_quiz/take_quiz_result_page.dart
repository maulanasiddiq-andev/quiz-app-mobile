import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/notifiers/quiz/take_quiz_notifier.dart';
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

    return Scaffold(
      appBar: customAppbarComponent("Hasil Kuis"),
      body: ConnectionCheckComponent(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Jawaban benar: "),
                        Text(state.quizHistory!.trueAnswers.toString()),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Nilai: "),
                        Text(state.quizHistory!.score.toString()),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Durasi Pengerjaan: "),
                        Text(formatTime(state.quizHistory!.duration)),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: CustomButtonComponent(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  text: "Kembali",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
