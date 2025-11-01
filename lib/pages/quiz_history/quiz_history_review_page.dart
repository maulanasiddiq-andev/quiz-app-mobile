import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/quiz_navigation_button_component.dart';
import 'package:quiz_app/models/quiz_history/answer_history_model.dart';
import 'package:quiz_app/models/quiz_history/question_history_model.dart';
import 'package:quiz_app/notifiers/quiz_history/quiz_history_detail_notifier.dart';

class QuizHistoryReviewPage extends ConsumerStatefulWidget {
  const QuizHistoryReviewPage({super.key});

  @override
  ConsumerState<QuizHistoryReviewPage> createState() => _QuizHistoryReviewPageState();
}

class _QuizHistoryReviewPageState extends ConsumerState<QuizHistoryReviewPage> {
  Color changeBackgroundColor(QuestionHistoryModel? questionHistory, AnswerHistoryModel answer) {
    if (questionHistory?.selectedAnswerOrder == answer.answerOrder && answer.isTrueAnswer) {
      return Colors.green;
    } else if(answer.isTrueAnswer) {
      return Colors.green;
    } else if (questionHistory?.selectedAnswerOrder == answer.answerOrder && answer.isTrueAnswer == false) {
      return Colors.red;
    }

    return Colors.transparent;
  }
  
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(quizHistoryDetailProvider);
    final notifier = ref.read(quizHistoryDetailProvider.notifier);
    QuestionHistoryModel? currentQuestion;

    if (state.questions.isNotEmpty) {
      currentQuestion = state.questions[state.questionIndex];
    }

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Review Kuis"),
      drawer: Drawer(
        child: ListView(
          children: [
            ...state.questions.asMap().entries.map((value) {
              final question = value.value;
              final key = value.key;

              return GestureDetector(
                onTap: () {
                  notifier.goToQuestion(key);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  color: state.questionIndex == key
                    ? colors.onSurface
                    : colors.surface,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          (key + 1).toString(),
                          style: TextStyle(
                            color: state.questionIndex == key
                              ? colors.surface
                              : colors.onSurface,
                            fontSize: 16
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            question.isAnswerTrue
                              ? Icons.check
                              : Icons.close,
                            color: question.isAnswerTrue
                              ? colors.primary
                              : colors.error,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
      body: ConnectionCheckComponent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: currentQuestion != null
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pertanyaan ${(state.questionIndex + 1).toString()}/${state.questions.length.toString()}"),
                          Text(currentQuestion.text),
                          currentQuestion.imageUrl != null
                            ? Image.network(
                                currentQuestion.imageUrl!,
                                width: double.infinity,
                              )
                            : SizedBox(),
                          RadioGroup(
                            groupValue: currentQuestion.selectedAnswerOrder,
                            onChanged: (_) {},
                            child: Column(
                              children: [
                                ...currentQuestion.answers.map((answer) {
                                  return Container(
                                    color: changeBackgroundColor(currentQuestion, answer),
                                    child: RadioListTile<int>(
                                      value: answer.answerOrder,
                                      title: answer.text != null ? Text(answer.text!) : null,
                                      secondary: answer.imageUrl != null
                                        ? Image.network(
                                            answer.imageUrl!,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    ),
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
        ),
      ),
    );
  }
}