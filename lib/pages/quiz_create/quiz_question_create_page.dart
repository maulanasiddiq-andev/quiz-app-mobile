import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/input_component.dart';
import 'package:quiz_app/components/quiz_navigation_button_component.dart';
import 'package:quiz_app/notifiers/quiz/quiz_create_notifier.dart';

class QuizQuestionCreatePage extends ConsumerStatefulWidget {
  const QuizQuestionCreatePage({super.key});

  @override
  ConsumerState<QuizQuestionCreatePage> createState() => _QuizQuestionCreatePageState();
}

class _QuizQuestionCreatePageState extends ConsumerState<QuizQuestionCreatePage> {
  late TextEditingController questionController;
  late List<TextEditingController> answerControllers;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController();
    answerControllers = [];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(quizCreateProvider);
    final notifier = ref.read(quizCreateProvider.notifier);
    var currentQuestion = state.questions[state.questionIndex];

    if (questionController.text != currentQuestion.text) {
      final oldSelection = questionController.selection;

      questionController.text = currentQuestion.text;

      final newSelection = TextSelection(
        baseOffset: oldSelection.baseOffset.clamp(0, questionController.text.length), 
        extentOffset: oldSelection.extentOffset.clamp(0, questionController.text.length)
      );

      questionController.selection = newSelection;
    }

    return Scaffold(
      appBar: customAppbarComponent(
        "Buat pertanyaan",
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pertanyaan ${state.questionIndex + 1}/${state.questions.length}"),
                    InputComponent(
                      title: "Pertanyaan", 
                      controller: questionController,
                      onChanged: (value) => notifier.updateQuestion(value),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {}, 
                          icon: Icon(Icons.image, size: 20)
                        ),
                        IconButton(
                          onPressed: () {}, 
                          icon: Icon(Icons.camera, size: 20)
                        ),
                      ],
                    ),
                    RadioGroup(
                      groupValue: currentQuestion.trueAnswerIndex,
                      onChanged: (int? value) {
                        notifier.determineTrueAnswer(value);
                      },
                      child: Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jawaban",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),  
                          ),
                          for (var i = 0; i < currentQuestion.answers.length; i++)
                            Row(
                              children: [
                                Radio(value: i),
                                Expanded(
                                  child: Column(
                                    children: [
                                      InputComponent(
                                        title: "Jawaban ${i + 1}", 
                                        controller: TextEditingController.fromValue(
                                          TextEditingValue(
                                            text: currentQuestion.answers[i].text,
                                            selection: TextSelection.collapsed(offset: currentQuestion.answers[i].text.length)
                                          )
                                        ),
                                        onChanged: (value) => notifier.updateAnswer(i, value),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            onPressed: () {}, 
                                            icon: Icon(Icons.image, size: 20)
                                          ),
                                          IconButton(
                                            onPressed: () {}, 
                                            icon: Icon(Icons.camera, size: 20)
                                          ),
                                          Expanded(child: SizedBox()),
                                          IconButton(
                                            onPressed: () {}, 
                                            icon: Icon(Icons.delete, size: 20, color: colors.error)
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                )
                              ],
                            )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 35),
                      child: TextButton(
                        onPressed: () {
                          notifier.addAnswer();
                        }, 
                        child: Text("Tambah Jawaban")
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: CustomButtonComponent(
              onTap: () {}, 
              text: "Hapus Pertanyaan",
              isError: true,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: QuizNavigationButtonComponent(
                  onTap: () => notifier.toPreviousQuestion(), 
                  icon: Icons.arrow_back,
                ),
              ),
              Expanded(
                child: QuizNavigationButtonComponent(
                  onTap: () async {
                    final result = await notifier.createQuiz();

                    if (result && context.mounted) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  }, 
                  icon: Icons.save
                )
              ),
              Expanded(
                child: QuizNavigationButtonComponent(
                  onTap: () => notifier.toNextQuestion(), 
                  icon: state.questionIndex < state.questions.length - 1
                    ? Icons.arrow_forward
                    : Icons.add,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}