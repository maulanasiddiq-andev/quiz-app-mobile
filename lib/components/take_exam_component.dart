import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/quiz_navigation_button_component.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/quiz_exam/question_exam_model.dart';
import 'package:quiz_app/notifiers/quiz/quiz_exam_notifier.dart';
import 'package:quiz_app/utils/format_time.dart';

class TakeExamComponent extends ConsumerStatefulWidget {
  final QuizModel quiz;
  const TakeExamComponent({super.key, required this.quiz});

  @override
  ConsumerState<TakeExamComponent> createState() => _TakeExamComponentState();
}

class _TakeExamComponentState extends ConsumerState<TakeExamComponent> {
  late int seconds;
  int duration = 0;
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
        setState(() {
          seconds--;
          duration++;
        });
      } else {
        timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(quizExamProvider);
    final notifier = ref.read(quizExamProvider.notifier);
    QuestionExamModel? currentQuestion;

    if (state.questions.isNotEmpty) {
      currentQuestion = state.questions[state.questionIndex];
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                formatTime(seconds),
                style: TextStyle(
                  color: seconds > 10
                    ? colors.onSurface
                    : seconds % 2 == 0
                      ? colors.onSurface
                      : colors.error
                ),
              )
            ),
          ),
          Expanded(
            child: currentQuestion == null
            ? SizedBox()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pertanyaan ${(state.questionIndex + 1).toString()}/${state.questions.length.toString()}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        currentQuestion.text,
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                      RadioGroup(
                        groupValue: currentQuestion.selectedAnswerOrder,
                        onChanged: (int? value) {
                          currentQuestion?.selectedAnswerOrder = value;
                        },
                        child: Column(
                          children: [
                            ...currentQuestion.answers.map((answer) {
                              return RadioListTile(
                                value: answer.answerOrder,
                                title: answer.text != null 
                                  ? Text(
                                      answer.text!,
                                      style: TextStyle(
                                        fontSize: 18
                                      ),
                                    ) 
                                  : null,
                                secondary: answer.imageUrl != null 
                                  ? Image.network(
                                      answer.imageUrl!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ),
          Row(
            children: [
              Expanded(
                child: QuizNavigationButtonComponent(
                  onTap: () => notifier.toPreviousQuestion(), 
                  icon: Icons.arrow_back,
                  text: "Sebelumnya",
                ),
              ),
              Expanded(
                child: QuizNavigationButtonComponent(
                  onTap: () {
                    if (state.questionIndex < state.questions.length - 1) {
                      notifier.toNextQuestion();
                    } else {
                      notifier.finishQuiz(duration);
                    }
                  }, 
                  icon: state.questionIndex < state.questions.length - 1
                    ? Icons.arrow_forward
                    : Icons.check,
                  text: state.questionIndex < state.questions.length - 1
                    ? "Selanjutnya"
                    : "Selesai",
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ],
      );
  }
}