import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/input_component.dart';
import 'package:quiz_app/components/pick_image_component.dart';
import 'package:quiz_app/models/quiz_create/question_create_model.dart';
import 'package:quiz_app/notifiers/quiz/quiz_create_notifier.dart';

class QuestionCreateComponent extends ConsumerStatefulWidget {
  final QuestionCreateModel question;
  final int questionIndex;
  final int questionsCount;
  const QuestionCreateComponent({
    super.key, 
    required this.question,
    required this.questionIndex,
    required this.questionsCount  
  });

  @override
  ConsumerState<QuestionCreateComponent> createState() => _QuestionCreateComponentState();
}

class _QuestionCreateComponentState extends ConsumerState<QuestionCreateComponent> {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> answerControllers = [];

  @override
  void initState() {
    super.initState();

    questionController.text = widget.question.text;
    for (var answer in widget.question.answers) {
      final controller = TextEditingController(text: answer.text);
      answerControllers.add(controller);
    }
  }

  @override
  void didUpdateWidget(covariant QuestionCreateComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.question.answers.length > oldWidget.question.answers.length) {
      final controller = TextEditingController();
      answerControllers.add(controller);
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    for (var controller in answerControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final notifier = ref.read(quizCreateProvider.notifier);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pertanyaan ${widget.questionIndex + 1}/${widget.questionsCount}"),
            InputComponent(
              title: "Pertanyaan", 
              controller: questionController,
              onChanged: (value) => notifier.updateQuestion(value),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     IconButton(
            //       onPressed: () {}, 
            //       icon: Icon(Icons.image, size: 20)
            //     ),
            //     IconButton(
            //       onPressed: () {}, 
            //       icon: Icon(Icons.camera, size: 20)
            //     ),
            //   ],
            // ),
            PickImageComponent(
              pickImage: () => notifier.pickQuestionImage(colors.primary, colors.onPrimary),
              image: widget.question.image,
            ),
            RadioGroup(
              groupValue: widget.question.trueAnswerIndex,
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
                  for (var i = 0; i < answerControllers.length; i++)
                    Row(
                      children: [
                        Radio(value: i),
                        Expanded(
                          child: Column(
                            children: [
                              InputComponent(
                                title: "Jawaban ${i + 1}", 
                                controller: answerControllers[i],
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
                                    onPressed: () {
                                      notifier.deleteAnswer(i);
                                    }, 
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
    );
  }
}