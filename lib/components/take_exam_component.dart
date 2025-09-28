import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/notifiers/quiz/quiz_exam_notifier.dart';

class TakeExamComponent extends ConsumerStatefulWidget {
  final QuizModel quiz;
  const TakeExamComponent({super.key, required this.quiz});

  @override
  ConsumerState<TakeExamComponent> createState() => _TakeExamComponentState();
}

class _TakeExamComponentState extends ConsumerState<TakeExamComponent> {
  late int seconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    seconds = widget.quiz.time * 60;
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }
  
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        timer?.cancel();
      }
    });
  }

  String timeFormatted() {
    var minute = (seconds ~/ 60).toString().padLeft(2, '0');
    var second = (seconds % 60).toString().padLeft(2, '0');

    return '$minute:$second';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizExamProvider);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(child: Text(timeFormatted())),
          ),
          Expanded(
            child: state.currentQuestion != null
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pertanyaan ${(state.questionIndex + 1).toString()}/${state.questions.length.toString()}",
                          ),
                          Text(state.currentQuestion!.text),
                          RadioGroup(
                            groupValue:
                                state.currentQuestion!.selectedAnswerOrder,
                            onChanged: (int? value) {
                              state.currentQuestion!.selectedAnswerOrder =
                                  value;
                            },
                            child: Column(
                              children: [
                                ...state.currentQuestion!.answers.map((answer) {
                                  return Row(
                                    children: [
                                      Radio(value: answer.answerOrder),
                                      answer.text != null
                                          ? Text(answer.text!)
                                          : SizedBox(),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () =>
                      ref.read(quizExamProvider.notifier).toPreviousQuestion(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(Icons.arrow_back),
                        Text("Sebelumnya", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () =>
                      ref.read(quizExamProvider.notifier).toNextQuestion(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Text(
                          state.questionIndex < state.questions.length - 1
                              ? "Selanjutnya"
                              : "Selesai",
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(
                          state.questionIndex < state.questions.length - 1
                              ? Icons.arrow_forward
                              : Icons.check,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
  }
}